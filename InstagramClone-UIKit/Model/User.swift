//
//  User.swift
//  ChatAppLearning
//
//  Created by Nihad Gurbanli on 12.02.26.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    var fullName: String?
    var profileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case name = "username"
        case email
        case fullName = "fullname"
        case profileImageURL
    }
}
