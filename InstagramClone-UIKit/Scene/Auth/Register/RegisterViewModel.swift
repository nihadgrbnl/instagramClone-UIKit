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
    var onLoading: ((Bool) -> Void)?
    
    init(repository: AuthRepository = FirebaseAuthRepository()) {
        self.repository = repository
    }
    
    func register() {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            onRegisterError?("Tüm alanları doldurunuz.")
            return
        }
        
        onLoading?(true)
        repository.register(email: email,
                            fullName: fullName,
                            username: username,
                            password: password) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.onLoading?(false)
                if let error {
                    self?.onRegisterError?(error.localizedDescription)
                } else {
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self?.onRegisterSuccess?()
                }
            }
        }
    }
}

