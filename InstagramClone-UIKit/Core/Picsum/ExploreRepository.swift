//
//  ExploreRepository.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import Foundation

protocol ExploreRepository {
    func fetchPhotos(page: Int, limit: Int, completion: @escaping (Result<[ExplorePhoto], AppError>) -> Void)
}
