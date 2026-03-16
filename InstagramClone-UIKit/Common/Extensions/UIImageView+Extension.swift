//
//  UIImageView+Extension.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 16.03.26.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImage(urlString: String?, placeholder: UIImage? = UIImage(systemName: "person.circle.fill"), completion: ((Bool) -> Void)? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = placeholder
            completion?(false)
            return
        }
        self.kf.setImage(with: url, placeholder: placeholder) { result in
            switch result {
            case .success: completion?(true)
            case .failure: completion?(false)
            }
        }
    }
}
