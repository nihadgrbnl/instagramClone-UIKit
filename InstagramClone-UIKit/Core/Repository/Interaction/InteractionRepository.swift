//
//  InteractionRepository.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import Foundation

protocol InteractionRepository {
    func likePost(postID: String, completion: @escaping (Result<Void, AppError>) -> Void)
    func unlikePost(postID: String, completion: @escaping (Result<Void, AppError>) -> Void)
    func fetchedLikedPostID(completion: @escaping (Result<Set<String>, AppError>) -> Void)
    func fetchComments(postID: String, completion: @escaping (Result<[Comment], AppError>) -> Void)
    func addComment(postID: String, text: String, ownerUsername: String, completion: @escaping (Result<Void, AppError>) -> Void)
}
