//
//  FirebaseRepository.swift
//  InstagramColne-UIKit
//
//  Created by Nihad Gurbanli on 20.02.26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


class FirebaseRepository : ChatRepository {
    
    private var db = Firestore.firestore()
    private let localRepository = MessageLocalRepository()
    
    var currentUserID : String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    
    func fetchUsers(otherUserID: String, completion: @escaping (User?, User?) -> Void) {
        guard let currentID = Auth.auth().currentUser?.uid else {
            completion(nil, nil)
            return
        }
        
        var fetchedCurrentUser: User?
        var fetchedChatUser : User?
        let group = DispatchGroup()
        
        group.enter()
        db.collection("users").document(currentID).getDocument{ snapshot, _ in
            if let document = snapshot {
                fetchedCurrentUser = try? document.data(as: User.self)
            }
            group.leave()
        }
        
        group.enter()
        db.collection("users").document(otherUserID).getDocument{ snapshot, _ in
            if let document = snapshot {
                fetchedChatUser = try? document.data(as: User.self)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(fetchedCurrentUser, fetchedChatUser)
        }
    }
    
    func joinRoom(otherUserID: String, completion: @escaping (String) -> Void) {
        let roomID = ChatUtils.getChatID(user1: currentUserID, user2: otherUserID)
        
        db.collection("chats").document(roomID).getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let doc = document, doc.exists {
                completion(roomID)
            } else {
                let data = ["users" : [self.currentUserID, otherUserID]]
                self.db.collection("chats").document(roomID).setData(data) { _ in
                    completion(roomID)
                }
            }
        }
    }
    
    func listenForMessages(chatID: String, completion: @escaping () -> Void) {
        db.collection("chats").document(chatID).collection("messages").order(by: "timeStamp").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion()
                return
            }
            
                        
            snapshot?.documentChanges.forEach { change in
                if change.type == .added {
                    if let message = try? change.document.data(as: Message.self) {
                        
                        print("☁️ FIREBASE: Yeni mesaj ağdan geldi -> Core Data'ya kaydediliyor...")
                        
                        //Get audio file from firebase storage
//                        var audioFileFromFirebaseStorage = "AudioFileFirebaseStorage"
                        
                        //Elave funksiya, audio  yazirsan file storage (device)
//                        var newPath = "newPath" //write function return newPath of audioFile
                        
                        //Write to local database (id, filepath, audio)
//                        var entity = "messageId, audioFileFromFirebaseStorage, newPath"
                        
                        
                        self.localRepository.save(chatID: chatID, model: message)
                    }
                }
            }
            completion()
        }
        
    }
    
    func sendMessages(type: MessageType, content: String, chatID: String, duration: Double?, currentUser: User, chatUser: User, completion: @escaping (Bool, (any Error)?) -> Void) {
        
        var newMessageData : [String : Any] = [
            "type" : type.rawValue,
            "content" : content,
            "senderID" : currentUserID,
            "timeStamp" : Date(),
        ]
        
        if let duration = duration {
            newMessageData["duration"] = duration
        }
        
        db.collection("chats").document(chatID).collection("messages").addDocument(data: newMessageData) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                completion(false, error)
                return
            }
            
            let previewText = switch type {
            case .text :
                content
            case .image :
                "📷 Fotoğraf"
            case .voice :
                "🎤 Sesli Mesaj"
            }
            
            let recentMessageData : [String: Any] = [
                "text" : previewText,
                "username" : chatUser.name,
                "profileImageURL" : chatUser.profileImageURL ?? "",
                "timeStamp" : Date(),
                "fromID" : self.currentUserID,
                "isSeen" : true,
            ]
            
            self.db.collection("users").document(self.currentUserID).collection("recent_messages").document(chatUser.id).setData(recentMessageData)
            
            let recipientMessageData : [String: Any] = [
                "text" : previewText,
                "username" : currentUser.name,
                "profileImageURL" : currentUser.profileImageURL ?? "",
                "timeStamp" : Date(),
                "fromID" : self.currentUserID,
                "isSeen" : false,
            ]
            
            db.collection("users").document(chatUser.id).collection("recent_messages").document(self.currentUserID).setData(recipientMessageData)
            
            completion(true, nil)
        }
    }
    
    func uploadImage(imageData: Data, chatID: String, completion: @escaping (String?, (any Error)?) -> Void) {
        let ref = Storage.storage().reference().child("chat_images/\(chatID)/\(UUID().uuidString).jpg")
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(nil, error)
                return
            } else {
                ref.downloadURL { url, error in
                    if let error {
                        completion(nil, error)
                        return
                    }
                    completion(url?.absoluteString, nil)
                }
            }
        }
    }
    
    func uploadAudio(audioURL: URL, chatID: String, completion: @escaping (String?, (any Error)?) -> Void) {
        
        let ref = Storage.storage().reference().child("chat_audios/\(chatID)/\(UUID().uuidString).m4a")
        
        ref.putFile(from: audioURL, metadata: nil) { _ , error in
            if let error {
                completion(nil, error)
                return
            } else {
                ref.downloadURL { url, error in
                    if let error {
                        completion(nil, error)
                        return
                    }
                    completion(url?.absoluteString, nil)
                }
            }
        }
    }
    
    func markAsRead(otherUserID: String, completion: @escaping (Bool) -> Void) {
        
        db.collection("users").document(currentUserID).collection("recent_messages").document(otherUserID).updateData(["isSeen" : true]) { error in
            if let error {
                print("DEBUG: Okundu isaretlenirken hata : \(error.localizedDescription)")
                completion(false)
            } else {
                print("DEBUG: mesaj basariyla okundu isaretlendi")
                completion(true)
            }
            
        }
    }
}
