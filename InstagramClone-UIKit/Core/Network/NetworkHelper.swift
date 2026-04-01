//
//  NetworkHelper.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import Foundation

class NetworkHelper {
    
    static let shared = NetworkHelper()
    private init() {}
    
    private let picsumBaseUrl = "https://picsum.photos"
    
    func configureURL(endpoint: String) -> String {
        picsumBaseUrl + endpoint
    }
}
