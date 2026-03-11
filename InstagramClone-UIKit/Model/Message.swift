//
//  Message.swift
//  ChatAppLearning
//
//  Created by Nihad Gurbanli on 11.02.26.
//

import Foundation
import FirebaseFirestore

struct Message: Codable, Identifiable{
    @DocumentID var id: String?
    var type : MessageType
    var content : String
    var senderID: String
    var timeStamp: Date
    var duration : Double?
    
    func isSentBy(userID: String) -> Bool {
        return senderID == userID
    }
    
    init(type: MessageType, content: String, senderID: String, timeStamp: Date) {
        self.type = type
        self.content = content
        self.senderID = senderID
        self.timeStamp = timeStamp
    }
}

enum MessageType : String, Codable {
    case text = "text"
    case voice = "voice"
    case image = "image"
}

