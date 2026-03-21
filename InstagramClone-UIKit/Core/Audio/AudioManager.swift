//
//  AudioManager.swift
//  InstagramClone-UIKit
//

import Foundation
import AVFoundation

struct AudioState {
    let messageId: String?
    let isPlaying: Bool
    let currentTime: TimeInterval
    let duration: TimeInterval
}

final class AudioManager: NSObject {
    
    static let shared = AudioManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var savedPositions: [String: TimeInterval] = [:]
    
    private(set) var currentMessageId: String?
    private(set) var isPlaying: Bool = false
    private(set) var currentTime: TimeInterval = 0
    private(set) var duration: TimeInterval = 0
        
    var onStateChanged: ((AudioState) -> Void)?
    
    private override init() {
        super.init()
        configureAudioSession()
        observeInterruptions()
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVAudioSession error: \(error.localizedDescription)")
        }
    }
    
    private func observeInterruptions() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRouteChange),
            name: AVAudioSession.routeChangeNotification,
            object: nil
        )
    }
    
    @objc private func handleInterruption(_ notification: Notification) {
        guard let info = notification.userInfo,
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if type == .began && self.isPlaying {
                self.audioPlayer?.pause()
                self.isPlaying = false
                self.stopTimer()
                self.notifyState()
            }
        }
    }
    
    @objc private func handleRouteChange(_ notification: Notification) {
        guard let info = notification.userInfo,
              let reasonValue = info[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if reason == .oldDeviceUnavailable && self.isPlaying {
                self.audioPlayer?.pause()
                self.isPlaying = false
                self.stopTimer()
                self.notifyState()
            }
        }
    }
    
    func play(id: String, url: URL) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if id == self.currentMessageId {
                self.toggleCurrentAudio(id: id)
            } else {
                self.playNewAudio(id: id, url: url)
            }
        }
    }
    
    private func toggleCurrentAudio(id: String) {
        if isPlaying {
            audioPlayer?.pause()
            savedPositions[id] = audioPlayer?.currentTime
            isPlaying = false
            stopTimer()
        } else {
            audioPlayer?.play()
            isPlaying = true
            startTimer()
        }
        notifyState()
    }
    
    private func playNewAudio(id: String, url: URL) {
        if let currentId = currentMessageId {
            savedPositions[currentId] = audioPlayer?.currentTime
        }
        audioPlayer?.stop()
        stopTimer()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            currentMessageId = id
            duration = audioPlayer?.duration ?? 0
            
            if let saved = savedPositions[id] {
                audioPlayer?.currentTime = saved
                currentTime = saved
            } else {
                currentTime = 0
            }
            
            audioPlayer?.play()
            isPlaying = true
            startTimer()
            notifyState()
        } catch {
            print("Audio play error: \(error.localizedDescription)")
        }
    }
    
    func stop() {
        audioPlayer?.stop()
        isPlaying = false
        stopTimer()
        currentMessageId = nil
        currentTime = 0
        notifyState()
    }
    
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
        currentTime = time
        notifyState()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentTime = self.audioPlayer?.currentTime ?? 0
            self.notifyState()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
        
    private func notifyState() {
        let state = AudioState(
            messageId: currentMessageId,
            isPlaying: isPlaying,
            currentTime: currentTime,
            duration: duration
        )
        onStateChanged?(state)
    }
    
    func toggle() {
        guard let id = currentMessageId else { return }
        toggleCurrentAudio(id: id)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        currentTime = 0
        savedPositions.removeValue(forKey: currentMessageId ?? "")
        stopTimer()
        notifyState()
    }
}

