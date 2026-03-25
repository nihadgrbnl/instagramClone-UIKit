//
//  FirebaseAdapter.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 24.03.26.
//

import Foundation
import FirebaseFirestore

struct FirebaseAdapter {
    static func toUser (document: DocumentSnapshot) -> User? {
        return try? document.data(as: User.self)
    }
    
    static func toMessage (document: QueryDocumentSnapshot) -> Message? {
        return try? document.data(as: Message.self)
    }
    
    static func toRecentMessage (document: QueryDocumentSnapshot) -> RecentMessages? {
        return try? document.data(as: RecentMessages.self)
    }
    
    static func toPost(document: QueryDocumentSnapshot) -> Post? {
        return try? document.data(as: Post.self)
    }
}
