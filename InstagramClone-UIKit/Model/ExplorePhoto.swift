//
//  ExplorePhoto.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import Foundation

struct ExplorePhoto: Codable {
    let id: String
    let author: String
    let downloadUrl: String

    enum CodingKeys: String, CodingKey {
        case id, author
        case downloadUrl = "download_url"
    }
}
