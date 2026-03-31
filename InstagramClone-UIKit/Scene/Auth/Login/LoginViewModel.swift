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
    var onLoading: ((Bool) -> Void)?
    
    init(repository: AuthRepository = FirebaseAuthRepository()) {
        self.repository = repository
    }
    
    func login() {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            onLoginError?("Email ve şifre boş olamaz.")
            return
        }
        
        onLoading?(true)
        repository.login(email: email,
                         password: password) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.onLoading?(false)
                if let error {
                    self?.onLoginError?(error.localizedDescription)
                } else {
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self?.onLoginSuccess?()
                }
            }
        }
    }
}

