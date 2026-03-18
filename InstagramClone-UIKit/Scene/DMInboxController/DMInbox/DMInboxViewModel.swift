//
//  DMInboxViewModel.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 13.03.26.
//

import Foundation

class DMInboxViewModel {
    
    var recentMessages = [RecentMessages]()
    var onDataUpdated: (() -> Void)?
    
    var currentUser: User?
    var onCurrentUserLoaded: ((User) -> Void)?
    
    private let repository: InboxRepository
    
    init(repository: InboxRepository = FirebaseInboxRepository()) {
        self.repository = repository
    }
    
    func fetchRecentMessages () {
        repository.fetchRecentMessages { [weak self] messages in
            guard let self = self else { return }
            print("Gelen mesaj sayısı: \(messages.count)")
            self.recentMessages = messages
            self.onDataUpdated?()
        }
    }
    
    func fetchCurrentUser() {
        repository.fetchCurrentUser { [weak self] user in
            guard let user = user else { return }
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.onCurrentUserLoaded?(user)
            }
        }
    }
}
