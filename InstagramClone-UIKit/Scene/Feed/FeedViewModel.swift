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
    
    var onDataUpdated: (() -> Void)?
    var onError: ((AppError) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    private let repository: FeedRepository
    
    init(repository: FeedRepository = FirebaseFeedRepository()) {
        self.repository = repository
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
            self?.onDataUpdated?()
        }
    }
}
