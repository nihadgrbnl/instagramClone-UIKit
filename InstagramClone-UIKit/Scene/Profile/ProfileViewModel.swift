//
//  ProfileViewModel.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 31.03.26.
//

import Foundation

class ProfileViewModel {
    
    private let repository: ProfileRepository
    
    var user: User?
    var posts: [Post] = []
    
    var onUserLoaded: (() -> Void)?
    var onPostsLoaded: (() -> Void)?
    var onError: ((AppError) -> Void)?
    
    init(repository: ProfileRepository = FirebaseProfileRepository()) {
        self.repository = repository
    }
    
    func fetchProfile() {
        repository.fetchCurrentUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                DispatchQueue.main.async { self?.onUserLoaded?() }
                self?.fetchPosts(uid: user.id)
            case .failure(let error):
                DispatchQueue.main.async { self?.onError?(error) }
            }
        }
    }
    
    private func fetchPosts(uid: String) {
        repository.fetchUserPosts(uid: uid) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
                DispatchQueue.main.async { self?.onPostsLoaded?() }
            case .failure(let error):
                DispatchQueue.main.async { self?.onError?(error) }
            }
        }
    }
}
