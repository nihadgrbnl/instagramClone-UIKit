//
//  Comment.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import Foundation
import FirebaseFirestore

struct Comment: Codable, Identifiable {
    @DocumentID var id: String?
    let text: String
    let ownerUID: String
    let ownerUsername: String
    let timeStamp: Date?
}
