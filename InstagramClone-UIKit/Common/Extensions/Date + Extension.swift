//
//  Date + Extension.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 31.03.26.
//

import Foundation

extension Date {
    func timeAgoString() -> String {
        let seconds = Int(-timeIntervalSinceNow)
        
        switch seconds {
        case ..<60:       return "Just now"
        case ..<3600:     return "\(seconds / 60)m"
        case ..<86400:    return "\(seconds / 3600)h"
        case ..<604800:   return "\(seconds / 86400)d"
        default:
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: self)
        }
    }
}
