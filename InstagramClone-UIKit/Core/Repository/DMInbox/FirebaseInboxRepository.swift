//
//  FirebaseInboxRepository.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 13.03.26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseInboxRepository: InboxRepository {
    
    private let db = Firestore.firestore()
    
    func fetchRecentMessages(completion: @escaping ([RecentMessages]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(currentUserID).collection("recent_messages")
            .order(by: "timeStamp", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                
                let recentMessages = documents.compactMap { document -> RecentMessages? in
                    guard document.documentID != currentUserID else { return nil }
                    return try? document.data(as: RecentMessages.self)
                }
                DispatchQueue.main.async {
                    completion(recentMessages)
                }
            }
    }
    
    func fetchCurrentUser(completion: @escaping (User?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        db.collection("users").document(uid).getDocument { snapshot, error in
            let user = try? snapshot?.data(as: User.self)
            completion(user)
        }
    }
}
