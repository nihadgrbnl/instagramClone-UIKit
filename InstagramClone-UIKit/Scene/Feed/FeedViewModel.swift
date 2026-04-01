//
//  FeedViewModel.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 31.03.26.
//

import Foundation

class FeedViewModel {
    
    var posts : [Post] = []
    var users: [String: User] = [:]
    var likedPostIDs: Set<String> = []
    
    var onDataUpdated: (() -> Void)?
    var onError: ((AppError) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    private let repository: FeedRepository
    private let interactionRepository: InteractionRepository
    
    init(repository: FeedRepository = FirebaseFeedRepository(),
         interactionRepository: InteractionRepository = FirebaseInteractionRepostiory()) {
        self.repository = repository
        self.interactionRepository = interactionRepository
    }
    
    func fetchPosts() {
        onLoading?(true)
        repository.fetchPosts { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoading?(false)
                switch result {
                case .success(let posts):
                    self?.posts = posts
                    self?.fetchUsers(posts: posts)
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
    
    func toggleLike(post: Post) {
        guard let postID = post.id else { return }
        let isLiked = likedPostIDs.contains(postID)
        
        if isLiked {
            likedPostIDs.remove(postID)
            if let index = posts.firstIndex(where: { $0.id == postID }) {
                posts[index].likes -= 1
            }
            interactionRepository.unlikePost(postID: postID) { _ in }
        } else {
            likedPostIDs.insert(postID)
            if let index = posts.firstIndex(where: { $0.id == postID }) {
                posts[index].likes += 1
            }
            interactionRepository.likePost(postID: postID) { _ in }
        }
        onDataUpdated?()
    }
    
    private func fetchUsers(posts: [Post]) {
        let uids = Array(Set(posts.map{ $0.ownerUID }))
        let group = DispatchGroup()
        
        uids.forEach { uid in
            group.enter()
            repository.fetchUser(uid: uid) { [weak self] user in
                if let user {
                    self?.users[uid] = user
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.fetchLikedPostIDs()
        }
    }
    
    private func fetchLikedPostIDs() {
        interactionRepository.fetchedLikedPostID { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let ids) = result {
                    self?.likedPostIDs = ids
                }
                self?.onDataUpdated?()
            }
        }
    }
}
