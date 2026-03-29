//
//  PostRepository.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 24.03.26.
//

import Foundation

protocol PostRepository {
    func uploadPost(imageData: Data, caption: String, completion: @escaping (Result<Void, AppError>) -> Void)
}
