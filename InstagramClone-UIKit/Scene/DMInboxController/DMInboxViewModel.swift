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
    
    private let repository: InboxRepository
    
    init(repository: InboxRepository = FirebaseInboxRepository()) {
        self.repository = repository
    }
    
    func fetchRecentMessages () {
        repository.fetchRecentMessages { [weak self] messages in
            guard let self = self else { return }
            self.recentMessages = messages
            self.onDataUpdated?()
        }
    }
}
