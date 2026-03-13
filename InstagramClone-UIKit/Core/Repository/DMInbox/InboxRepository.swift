//
//  InboxRepository.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 13.03.26.
//

import Foundation

protocol InboxRepository {
    func fetchRecentMessages(completion: @escaping ([RecentMessages]) -> Void)
}
