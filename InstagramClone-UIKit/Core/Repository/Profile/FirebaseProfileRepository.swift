//
//  FirebaseProfileRepository.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 31.03.26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseProfileRepository: ProfileRepository {
    
    private let db = Firestore.firestore()
    
    func fetchCurrentUser(completion: @escaping (Result<User, AppError>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(.noUser))
            return
        }
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error {
                completion(.failure(.uploadFailed(error.localizedDescription)))
                return
            }
            guard let snapshot, let user = try? snapshot.data(as: User.self) else {
                completion(.failure(.unknown))
                return
            }
            completion(.success(user))
        }
    }
    
    func fetchUserPosts(uid: String, completion: @escaping (Result<[Post], AppError>) -> Void) {
        db.collection("posts")
            .whereField("ownerUID", isEqualTo: uid)
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
}
