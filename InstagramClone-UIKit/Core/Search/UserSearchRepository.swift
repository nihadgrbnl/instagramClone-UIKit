//
//  UserSearchRepository.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import Foundation

protocol UserSearchRepository {
    func searchUsers(query: String, completion: @escaping (Result<[User], AppError>) -> Void)
}
