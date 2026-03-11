//
//  MessageLocalDataSource.swift
//  ChatAppLearning
//
//  Created by Nihad Gurbanli on 27.02.26.
//

import Foundation

protocol MessageLocalDataSource {
    func save(chatID: String, model: Message)
    
    func fetch(chatID: String) -> [Message]
    
    func delete(chatID: String) 
}
