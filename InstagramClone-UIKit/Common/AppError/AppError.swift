//
//  AppError.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 29.03.26.
//

import Foundation

enum AppError: Error {
    case imageConversionFailed
    case noUser
    case emptyCaption
    case uploadFailed(String)
    case unknown
    
    var userFriendlyMessage: String {
        switch self {
        case .imageConversionFailed:
            return "Fotoğraf işlenemedi."
        case .noUser:
            return "Kullanıcı oturumu bulunamadı."
        case .emptyCaption:
            return "Açıklama boş olamaz."
        case .uploadFailed(let msg):
            return msg
        case .unknown:
            return "Bilinmeyen bir hata oluştu."
        }
    }
}
