//
//  ProfileRepository.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 31.03.26.
//

import Foundation

protocol ProfileRepository {
    func fetchCurrentUser(completion: @escaping (Result<User, AppError>) -> Void)
    func fetchUserPosts(uid: String, completion: @escaping (Result<[Post], AppError>) -> Void)
}
