//
//  FirebasePostRepository.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 29.03.26.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class FirebasePostRepository: PostRepository {
    
    private let db = Firestore.firestore()
    
    func uploadPost(imageData: Data, caption: String, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(.noUser))
            return
        }
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference().child("post_images/\(filename).jpg")
        
        ref.putData(imageData, metadata: nil) { [weak self] _, error in
            if let error {
                completion(.failure(.uploadFailed(error.localizedDescription)))
                return
            }
            
            ref.downloadURL { [weak self] url, error in
                guard let self, let imageURL = url?.absoluteString else {
                    completion(.failure(.uploadFailed(error?.localizedDescription ?? "URL alınamadı.")))
                    return
                }
                
                let postData: [String: Any] = [
                    "imageURL": imageURL,
                    "caption": caption,
                    "ownerUID": uid,
                    "timeStamp": Date(),
                    "likes": 0
                ]
                
                self.db.collection("posts").addDocument(data: postData) { error in
                    if let error {
                        completion(.failure(.uploadFailed(error.localizedDescription)))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }
}

