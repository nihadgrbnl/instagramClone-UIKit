//
//  FeedRepository.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 31.03.26.
//

import Foundation

protocol FeedRepository {
    func fetchPosts (completion: @escaping (Result<[Post], AppError>) -> Void)
    func fetchUser(uid: String, completion: @escaping (User?) -> Void)
}
