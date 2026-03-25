//
//  Post.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 24.03.26.
//

import Foundation
import FirebaseFirestore

struct Post: Codable, Identifiable {
    @DocumentID var id: String?
    let imageURL: String
    let caption: String
    let ownerUID: String
    let timeStamp: Date
    let likes: Int
}
