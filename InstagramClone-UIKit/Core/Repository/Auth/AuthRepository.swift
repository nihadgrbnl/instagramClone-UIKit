//
//  AuthRepository.swift
//  ChatAppLearning
//
//  Created by Nihad Gurbanli on 26.02.26.
//

import Foundation

protocol AuthRepository {
    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void)
    
    func logout()
    
    func register(email: String, username: String, password: String, completion: @escaping (Bool, Error?) -> Void)
}
