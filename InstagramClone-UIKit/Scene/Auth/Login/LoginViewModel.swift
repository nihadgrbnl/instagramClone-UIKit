//
//  LoginViewModel.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 12.03.26.
//

import Foundation

class LoginViewModel {
    
    var email: String = ""
    var password: String = ""
    
    private let repository: AuthRepository
    
    var onLoginSuccess: (() -> Void)?
    var onLoginError: ((String) -> Void)?
    
    init(repository: AuthRepository = FirebaseAuthRepository()) {
        self.repository = repository
    }
    
    func login() {
        repository.login(email: email,
                         password: password) { success, error in
            if let error {
                self.onLoginError?(error.localizedDescription)
            } else {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.onLoginSuccess?()
            }
        }
    }
}
