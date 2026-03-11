//
//  RecentMessages.swift
//  ChatAppLearning
//
//  Created by Nihad Gurbanli on 16.02.26.
//

import Foundation
import FirebaseFirestore

struct RecentMessages : Codable, Identifiable {
    @DocumentID var id: String?
    
    let text: String
    let username: String
    let profileImageURL: String?
    let timeStamp: Date
    let fromID : String
    var isSeen: Bool
    
    var timeString: String {
        return timeStamp.formatted(date: .omitted, time: .shortened)
    }
}
