//
//  FirebaseFeedRepository.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 31.03.26.
//

import Foundation
import FirebaseFirestore

class FirebaseFeedRepository : FeedRepository {
    
    private let db = Firestore.firestore()
    
    func fetchPosts(completion: @escaping (Result<[Post], AppError>) -> Void) {
        db.collection("posts")
            .order(by: "timeStamp", descending: true)
            .getDocuments { snapshot, error in
                if let error {
                    completion(.failure(.uploadFailed(error.localizedDescription)))
                    return
                }
                let posts = snapshot?.documents.compactMap { try? $0.data(as: Post.self) } ?? []
                completion(.success(posts))
            }
    }
    
    func fetchUser(uid: String, completion: @escaping (User?) -> Void) {
        db.collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                guard let snapshot else {
                    completion(nil)
                    return
                }
                completion(FirebaseAdapter.toUser(document: snapshot))
            }
    }
}
