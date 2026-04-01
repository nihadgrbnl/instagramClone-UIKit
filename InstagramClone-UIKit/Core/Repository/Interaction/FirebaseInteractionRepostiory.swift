//
//  FirebaseInteractionRepostiory.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseInteractionRepostiory: InteractionRepository {
    
    private let db = Firestore.firestore()
    private var currentUID: String? = Auth.auth().currentUser?.uid
    
    func likePost(postID: String, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let uid = currentUID else {
            completion(.failure(.noUser))
            return }
        
        let postRef = db.collection("posts").document(postID)
        let likeRef = db.collection("users").document(uid).collection("likedPosts").document(postID)
        
        let batch = db.batch()
        batch.setData(["postID" : postID], forDocument: likeRef)
        batch.updateData(["likes" : FieldValue.increment(Int64(1))], forDocument: postRef)
        
        batch.commit { error in
            if let error {
                completion(.failure(.uploadFailed(error.localizedDescription)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func unlikePost(postID: String, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let uid  = currentUID else {
            completion(.failure(.noUser))
            return
        }
        
        let postRef = db.collection("posts").document(postID)
        let likeRef = db.collection("users").document(uid).collection("likedPosts").document(postID)
        
        let batch = db.batch()
        batch.deleteDocument(likeRef)
        batch.updateData(["likes" : FieldValue.increment(Int64(-1))], forDocument: postRef)
        
        batch.commit { error in
            if let error {
                completion(.failure(.uploadFailed(error.localizedDescription)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchedLikedPostID(completion: @escaping (Result<Set<String>, AppError>) -> Void) {
        guard let uid  = currentUID else {
            completion(.failure(.noUser))
            return
        }
        
        db.collection("users").document(uid).collection("likedPosts")
            .getDocuments { snapshot, error in
                if let error {
                    completion(.failure(.uploadFailed(error.localizedDescription)))
                }
                let ids = Set(snapshot?.documents.map { $0.documentID } ?? [])
                completion(.success(ids))
            }
    }
    
    func fetchComments(postID: String, completion: @escaping (Result<[Comment], AppError>) -> Void) {
        db.collection("posts").document(postID).collection("comments")
            .order(by: "timeStamp", descending: false)
            .getDocuments { snapshot, error in
                if let error {
                    completion(.failure(.uploadFailed(error.localizedDescription)))
                }
                let comments = snapshot?.documents.compactMap { try? $0.data(as: Comment.self) } ?? []
                completion(.success(comments))
            }
    }
    
    func addComment(postID: String, text: String, ownerUsername: String, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let uid  = currentUID else {
            completion(.failure(.noUser))
            return
        }
        
        let data : [String: Any] = [
            "text" : text,
            "ownerUID" : uid,
            "ownerUsername" : ownerUsername,
            "timeStamp" : FieldValue.serverTimestamp()
        ]
        
        db.collection("posts").document(postID).collection("comments")
            .addDocument(data: data) { error in
                if let error {
                    completion(.failure(.uploadFailed(error.localizedDescription)))
                } else {
                    completion(.success(()))
                }
            }
    }
}
