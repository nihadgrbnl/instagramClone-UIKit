//
//  NetworkManager.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Codable>(model: T.Type,
                             endpoint: PicsumEndpoint,
                             completion: @escaping (Result<T, AppError>) -> Void) {
        
        let urlString = NetworkHelper.shared.configureURL(endpoint: endpoint.path)
        
        AF.request(urlString, method: .get)
            .validate()
            .responseDecodable(of: model) { response in
                switch response.result {
                case .success(let decoded):
                    completion(.success(decoded))
                case .failure(let error):
                    completion(.failure(.uploadFailed(error.localizedDescription)))
                }
            }
    }
}
