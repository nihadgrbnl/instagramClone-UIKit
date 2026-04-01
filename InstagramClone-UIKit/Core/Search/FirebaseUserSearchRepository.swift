//
//  FirebaseUserSearchRepository.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import Foundation
import FirebaseFirestore

class FirebaseUserSearchRepository: UserSearchRepository {
    
    private let db = Firestore.firestore()
    
    func searchUsers(query: String, completion: @escaping (Result<[User], AppError>) -> Void) {
        db.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: query)
            .whereField("username", isLessThan: query + "\u{f8ff}")
            .limit(to: 20)
            .getDocuments { snapshot, error in
                if let error {
                    completion(.failure(.uploadFailed(error.localizedDescription)))
                    return
                }
                let users = snapshot?.documents.compactMap {
                    FirebaseAdapter.toUser(document: $0)
                } ?? []
                completion(.success(users))
            }
    }
}
