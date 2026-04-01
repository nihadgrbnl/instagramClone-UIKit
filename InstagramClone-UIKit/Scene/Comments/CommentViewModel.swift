//
//  CommentViewModel.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class CommentViewModel {
    
    var comments: [Comment] = []
    
    private let postID : String
    var currentUsername : String = ""
    
    private let repository: InteractionRepository
    
    var onDataUpdated: (() -> Void)?
    var onError: ((AppError) -> Void)?
    
    init (postID: String, repository: InteractionRepository = FirebaseInteractionRepostiory()) {
        self.postID = postID
        self.repository = repository
    }
    
    private func fetchCurrentUsername() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { [weak self] snapshot, _ in
            if let data = snapshot?.data(), let username = data["username"] as? String {
                self?.currentUsername = username
            }
        }
    }
    
    func fetchComments() {
        repository.fetchComments(postID: postID) { [weak self] result in
            switch result {
            case .success(let comments):
                self?.comments = comments
                DispatchQueue.main.async {
                    self?.onDataUpdated?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError?(error)
                }
            }
        }
    }
    
    func postComment(text: String) {
        repository.addComment(postID: postID,
                              text: text,
                              ownerUsername: currentUsername) { [weak self] result in
            switch result {
            case .success:
                self?.fetchComments()
            case .failure(let error):
                DispatchQueue.main.async { self?.onError?(error) }
            }
        }
    }
}
