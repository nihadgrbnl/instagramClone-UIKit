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
                    try? document.data(as: RecentMessages.self)
                }
                
                DispatchQueue.main.async {
                    completion(recentMessages)
                }
            }
    }
}
