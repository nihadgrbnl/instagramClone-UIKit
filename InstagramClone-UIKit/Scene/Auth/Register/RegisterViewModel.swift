//
//  RegisterViewModel.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 12.03.26.
//

import Foundation

class RegisterViewModel {
    
    var email: String = ""
    var fullName: String = ""
    var username: String = ""
    var password: String = ""
    
    private let repository: AuthRepository
    
    var onRegisterSuccess: (() -> Void)?
    var onRegisterError: ((String) -> Void)?
    
    init(repository: AuthRepository = FirebaseAuthRepository()) {
        self.repository = repository
    }
    
    func register() {
        repository.register(email: email,
                            username: username,
                            password: password) { success, error in
            if let error {
                self.onRegisterError?(error.localizedDescription)
            } else {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.onRegisterSuccess?()
            }
        }
    }
}
