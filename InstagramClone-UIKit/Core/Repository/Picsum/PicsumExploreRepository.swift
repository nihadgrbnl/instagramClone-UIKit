//
//  PicsumExploreRepository.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import Foundation

class PicsumExploreRepository : ExploreRepository {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func fetchPhotos(page: Int, limit: Int, completion: @escaping (Result<[ExplorePhoto], AppError>) -> Void) {
        networkManager.request(model: [ExplorePhoto].self,
                               endpoint: .list(page: page, limit: limit),
                               completion: completion)
    }
}
