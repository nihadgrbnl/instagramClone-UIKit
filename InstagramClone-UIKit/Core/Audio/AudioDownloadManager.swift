//
//  AudioDownloadManager.swift
//  InstagramClone-UIKit
//

import Foundation

final class AudioDownloadManager {
    
    static let shared = AudioDownloadManager()
    private init() {}
    
    private let fileManager = FileManager.default
    private var activeDownloads: [String: URLSessionDownloadTask] = [:]
    
    private lazy var audioDirectory: URL = {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let voiceFolder = documentsPath.appendingPathComponent("VoiceMessages")
        
        if !fileManager.fileExists(atPath: voiceFolder.path) {
            try? fileManager.createDirectory(at: voiceFolder, withIntermediateDirectories: true, attributes: nil)
        }
        return voiceFolder
    }()
    
    func downloadAudio(urlString: String, completion: @escaping (URL?) -> Void) {
        print("DEBUG: download started — \(urlString)")
        guard let url = URL(string: urlString) else {
            print("DEBUG: invalid URL")
            completion(nil)
            return
        }
        
        // ESKİ KOD: let fileName = url.lastPathComponent
        // YENİ KOD: Firebase URL'sinden sadece bizim belirlediğimiz eşsiz ID'yi (UUID.m4a) güvenle çekiyoruz:
        let cleanPath = urlString.components(separatedBy: "?").first ?? urlString
        let fileName = cleanPath.components(separatedBy: "%2F").last ?? (UUID().uuidString + ".m4a")
        
        let localURL = audioDirectory.appendingPathComponent(fileName)
        
        // Cache'de varsa hemen dön
        if fileManager.fileExists(atPath: localURL.path) {
            completion(localURL)
            return
        }
        
        // duplicate
        guard activeDownloads[urlString] == nil else { return }
        
        let task = URLSession.shared.downloadTask(with: url) { [weak self] tempURL, _, error in
            guard let self = self else { return }
            self.activeDownloads.removeValue(forKey: urlString)
            
            guard let tempURL = tempURL, error == nil else {
                print("DEBUG: download failed — \(error?.localizedDescription ?? "unknown")")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            do {
                if self.fileManager.fileExists(atPath: localURL.path) {
                    try self.fileManager.removeItem(at: localURL)
                }
                try self.fileManager.moveItem(at: tempURL, to: localURL)
                print("DEBUG: download success — \(localURL)")
                DispatchQueue.main.async { completion(localURL) }
            } catch {
                // EKLENEN KISIM: Artık bir hata olursa konsolda bağırarak bize söyleyecek!
                print("DEBUG: Dosya kaydetme hatası — \(error.localizedDescription)")
                DispatchQueue.main.async { completion(nil) }
            }
        }
        
        activeDownloads[urlString] = task
        task.resume()
    }
    
    func isAudioCached(urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        let fileName = url.lastPathComponent
        let localURL = audioDirectory.appendingPathComponent(fileName)
        return fileManager.fileExists(atPath: localURL.path)
    }
    
    func cancelDownload(urlString: String) {
        activeDownloads[urlString]?.cancel()
        activeDownloads.removeValue(forKey: urlString)
    }
}

