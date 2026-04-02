//
//  PicsumEndpoint.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import Foundation

enum PicsumEndpoint {
    case list(page: Int, limit: Int)
    
    var path: String {
        switch self {
        case .list(let page,let limit):
            return "/v2/list?page=\(page)&limit=\(limit)"
        }
    }
}
