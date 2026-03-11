//
//  AudioDownloadManager.swift
//  ChatAppLearning
//
//  Created by Nihad Gurbanli on 06.03.26.
//

import Foundation

class AudioDownloadManager {
    
    static let shared = AudioDownloadManager()
    
    private let fileManager = FileManager.default
    
    private var audioDirectory : URL {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let voiceFolder = documentsPath.appendingPathComponent("VoiceMessages")
        
        if !fileManager.fileExists(atPath: voiceFolder.path) {
            try? fileManager.createDirectory(at: voiceFolder, withIntermediateDirectories: true, attributes: nil)
        }
        return voiceFolder
    }
    
    func downloadAudio(urlString: String, completion: @escaping(URL?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        
        let directory = audioDirectory
        let fileName = url.lastPathComponent.components(separatedBy: "/").last ?? UUID().uuidString + ".m4a"
        let localURL = directory.appendingPathComponent(fileName)
        
        
        if fileManager.fileExists(atPath: localURL.path) {
            print(" Dosya zaten cihazda var, anında açılıyor: \(fileName)")
            completion(localURL)
            return
        }
                
        print(" Dosya cihazda yok, Firebase'den indiriliyor...")
        URLSession.shared.downloadTask(with: url) { tempURL, response, error in
            guard let tempURL = tempURL, error == nil else {
                print("İndirme hatası: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            do {
                try self.fileManager.moveItem(at: tempURL, to: localURL)
                print(" Dosya başarıyla kaydedildi: \(fileName)")
                
                DispatchQueue.main.async {
                    completion(localURL)
                }
            } catch {
                print("Dosya kaydetme hatası: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func isAudioCached(urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        let fileName = url.lastPathComponent
        let localURL = audioDirectory.appendingPathComponent(fileName)
        return fileManager.fileExists(atPath: localURL.path)
    }
}
