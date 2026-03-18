//
//  AudioRecorderManager.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 18.03.26.
//

import Foundation
import AVFoundation

final class AudioRecorderManager: NSObject {
    
    static let shared = AudioRecorderManager()
    private override init() { super.init() }
    
    private var audioRecorder: AVAudioRecorder?
    private var recordingURL: URL?
    private var startTime: Date?
    
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            completion(granted)
        }
    }
    
    func startRecording() -> Bool {
        let fileName = UUID().uuidString + ".m4a"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let audioURL = documentsPath.appendingPathComponent(fileName)
        recordingURL = audioURL
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder?.record()
            startTime = Date()
            return true
        } catch {
            print("Recording error: \(error.localizedDescription)")
            return false
        }
    }
    
    func stopRecording() -> (url: URL, duration: Double)? {
        guard let recorder = audioRecorder,
              let url = recordingURL,
              let start = startTime else { return nil }
        
        recorder.stop()
        let duration = Date().timeIntervalSince(start)
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        
        audioRecorder = nil
        startTime = nil
        
        return (url: url, duration: duration)
    }
    
    func cancelRecording() {
        audioRecorder?.stop()
        if let url = recordingURL {
            try? FileManager.default.removeItem(at: url)
        }
        audioRecorder = nil
        recordingURL = nil
        startTime = nil
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
    }
}
