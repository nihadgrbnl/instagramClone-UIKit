//
//  MockAuthRepository.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 29.03.26.
//

import Foundation

final class MockAuthRepository: AuthRepository {
    func login(email: String, password: String, completion: @escaping (Bool, (any Error)?) -> Void) {
        completion(true, nil)
    }
    
    func logout() {}
    
    func register(email: String, fullName: String, username: String, password: String, completion: @escaping (Bool, (any Error)?) -> Void) {}
}
