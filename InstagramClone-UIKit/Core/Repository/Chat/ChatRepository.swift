//
//  ChatRepository.swift
//  InstagramColne-UIKit
//
//  Created by Nihad Gurbanli on 20.02.26.
//

import Foundation

protocol ChatRepository {
    
    var currentUserID : String { get }
    
    func fetchUsers (otherUserID: String, completion: @escaping (User?, User?) -> Void)
    
    func joinRoom(otherUserID: String, completion: @escaping (String) -> Void)
    
    func listenForMessages(chatID: String, completion: @escaping () -> Void)
    
    func sendMessages(type: MessageType, content : String, chatID: String, duration: Double?, currentUser: User, chatUser: User, completion: @escaping(Bool, Error?) -> Void)
    
    func uploadImage(imageData: Data, chatID: String, completion: @escaping(String?, Error?) -> Void)
    
    func uploadAudio(audioURL: URL, chatID: String, completion: @escaping(String?, Error?) -> Void)
    
    func markAsRead(otherUserID: String, completion: @escaping (Bool) -> Void)
}
