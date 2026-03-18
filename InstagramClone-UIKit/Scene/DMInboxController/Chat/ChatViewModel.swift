//
//  ChatViewModel.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 14.03.26.
//

import Foundation

class ChatViewModel {
    
    var messages: [Message] = []
    var messageText: String = ""
    var chatID: String = ""
    var chatUser: User?
    var currentUser: User?
    
    var onDataUpdated: (() -> Void)?
    var onUserLoaded: (() -> Void)?
    var onAudioStateChanged: ((AudioState) -> Void)?
    
    private let repository: ChatRepository
    private let localRepository: MessageLocalDataSource
    
    var currentID: String {
        return repository.currentUserID
    }
    
    init(repository: ChatRepository = FirebaseRepository(),
         localRepository: MessageLocalDataSource = MessageLocalRepository()) {
        self.repository = repository
        self.localRepository = localRepository
    }
    
    func fetchUsers(otherUserID: String) {
        repository.fetchUsers(otherUserID: otherUserID) { [weak self] fetchedCurrentUser, fetchedChatUser in
            self?.currentUser = fetchedCurrentUser
            self?.chatUser = fetchedChatUser
            DispatchQueue.main.async {
                self?.onUserLoaded?()
            }
        }
    }
    
    func joinRoom(otherUserID: String) {
        repository.joinRoom(otherUserID: otherUserID) { [weak self] roomID in
            guard let self = self else { return }
            self.chatID = roomID
            self.fetchUsers(otherUserID: otherUserID)
            self.listenForMessages(chatID: chatID)
        }
    }
    
    func listenForMessages(chatID: String) {
        repository.listenForMessages(chatID: chatID) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let fetched = self.localRepository.fetch(chatID: chatID)
                print("Mesaj sayisi: \(fetched.count)")
                self.messages = fetched
                self.onDataUpdated?()
            }
        }
    }
    
    func sendMessage(type: MessageType, content: String, duration: Double? = nil) {
        guard let currentUser = currentUser,
              let chatUser = chatUser else { return }
        repository.sendMessages(type: type,
                                content: content,
                                chatID: chatID,
                                duration: duration,
                                currentUser: currentUser,
                                chatUser: chatUser) { [weak self] success, error in
            if let error {
                print("send messages error \(error.localizedDescription)")
            } else if success {
                DispatchQueue.main.async {
                    self?.messageText = ""
                }
            }
        }
    }
    
    func sendImageMessage(imageData: Data) {
        guard let currentUser = currentUser,
              let chatUser = chatUser else { return }
        repository.uploadImage(imageData: imageData,
                               chatID: chatID) { [weak self] urlString, error in
            if let error {
                print("image upload error: \(error.localizedDescription)")
                return
            }
            guard let urlString = urlString, let self = self else { return }
            self.repository.sendMessages(type: .image,
                                         content: urlString,
                                         chatID: chatID,
                                         duration: nil,
                                         currentUser: currentUser,
                                         chatUser: chatUser) { _, _ in }
        }
    }
    
    func setupAudioManager() {
        AudioManager.shared.onStateChanged = { [weak self] state in
            self?.onAudioStateChanged?(state)
        }
    }
    
    func handlePlayTapped(messageID: String, audioURL: String) {
        AudioDownloadManager.shared.downloadAudio(urlString: audioURL) { url in
            guard let url = url else {
                print("HATA: İndirme başarısız, yükleniyor ikonu durduruluyor.")
                // Arayüze sahte bir "durdu" sinyali gönderip yükleme ikonunu kapatıyoruz:
                let failedState = AudioState(messageId: messageID, isPlaying: false, currentTime: 0, duration: 0)
                AudioManager.shared.onStateChanged?(failedState)
                return
            }
            AudioManager.shared.play(id: messageID, url: url)
        }
    }
    
    func stopAudio() {
        AudioManager.shared.stop()
    }
    
    func toggleRecording(permissionGranted: Bool) -> Bool {
        guard permissionGranted else { return false }
        if AudioRecorderManager.shared.isRecording {
            guard let result = AudioRecorderManager.shared.stopRecording() else { return false }
            sendVoiceMessages(localAudioURL: result.url, duration: result.duration)
            return false
        } else {
            return AudioRecorderManager.shared.startRecording()
        }
    }
    
    
    func sendVoiceMessages(localAudioURL: URL, duration: Double) {
        guard let currentUser = currentUser,
              let chatUser = chatUser else { return }
        repository.uploadAudio(audioURL: localAudioURL,
                               chatID: chatID) { [weak self] urlString, error in
            guard let urlString = urlString, let self = self else { return }
            self.repository.sendMessages(type: .voice,
                                         content: urlString,
                                         chatID: chatID,
                                         duration: duration,
                                         currentUser: currentUser,
                                         chatUser: chatUser) { _,_ in }
        }
    }
    
    func markAsRead() {
        guard let chatUser = chatUser else { return }
        repository.markAsRead(otherUserID: chatUser.id) { success in
            if success { print("Mesajlar okundu isaretlendi.") }
        }
    }
    
}
