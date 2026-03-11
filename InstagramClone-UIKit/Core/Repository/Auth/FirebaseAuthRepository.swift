//
//  FirebaseAuthRepository.swift
//  ChatAppLearning
//
//  Created by Nihad Gurbanli on 26.02.26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthRepository: AuthRepository {
    
    func login(email: String, password: String, completion: @escaping (Bool, (any Error)?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error{
                print(error.localizedDescription)
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            
        } catch {
            print("Error while exiting")
        }
    }
    
    func register(email: String, username: String, password: String, completion: @escaping (Bool, (any Error)?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                print(error.localizedDescription)
                completion(false, error)
            } else {
                guard let uid = result?.user.uid else { return }
                Firestore.firestore().collection("users").document(uid).setData([
                    "uid": uid,
                    "username": username,
                    "email": email
                ])
                { error in
                    if let error {
                        print("Firestore'a yazılamadı: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        completion(true, nil)
                    }
                }
            }
        }
    }
}
