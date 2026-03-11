//
//  AudioManager.swift
//  ChatAppLearning
//
//  Created by Nihad Gurbanli on 20.02.26.
//

import Foundation
import AVFoundation
import Combine

class AudioManager: ObservableObject {
    
    static let shared = AudioManager()
    
    var audioPlayer : AVAudioPlayer?
    
    @Published var savedPosition : [String : TimeInterval] = [:]
    @Published var currentID : String?
    @Published var isPlaying : Bool = false
    @Published var currentTime : TimeInterval = 0
    @Published var duration : TimeInterval = 0
    
    private var timer : AnyCancellable?
    
    private init() {}
    
    func play (id: String, url: URL ) {
        
        if id == currentID {
            if isPlaying {
                audioPlayer?.pause()
                savedPosition[id] = audioPlayer?.currentTime
                isPlaying = false
                stopTimer()
            } else {
                audioPlayer?.play()
                isPlaying = true
                startTimer()
            }
        } else {
            if let currentID {
                savedPosition[currentID] = audioPlayer?.currentTime
            }
            audioPlayer?.stop()
            stopTimer()
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                currentID = id
                duration = audioPlayer?.duration ?? 0
                
                if let saved = savedPosition[id] {
                    audioPlayer?.currentTime = saved
                    currentTime = saved
                } else {
                    currentTime = 0
                }
                
                audioPlayer?.play()
                isPlaying = true
                startTimer()
            } catch {
                print("Ses oynatma hatası: \(error.localizedDescription)")
            }
            
        }
        
        
    }
    
    func stop() {
        audioPlayer?.stop()
        isPlaying = false
        stopTimer()
        currentID = nil
        currentTime = 0
    }
    
    func seek(to time : TimeInterval) {
        audioPlayer?.currentTime = time
        currentTime = time
    }
    
    func startTimer() {
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                self?.currentTime = self?.audioPlayer?.currentTime ?? 0
            })
    }
    
    func stopTimer () {
        timer?.cancel()
        timer = nil
    }
}
