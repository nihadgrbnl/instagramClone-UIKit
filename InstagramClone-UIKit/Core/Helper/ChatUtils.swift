//
//  ChatUtils.swift
//  ChatAppLearning
//
//  Created by Nihad Gurbanli on 13.02.26.
//

import Foundation

struct ChatUtils {
    static func getChatID(user1: String, user2: String) -> String{
        if user1 > user2 {
            return user1 + "_" + user2
        } else {
            return user2 + "_" + user1
        }
    }
}
