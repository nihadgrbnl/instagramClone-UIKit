//
//  AlertBuilder.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 29.03.26.
//

import UIKit

class AlertBuilder {
    private var title: String = ""
    private var message: String = ""
    private var primaryTitle: String = "OK"
    private var primaryAction: (() -> Void)? = nil
    private var secondaryTitle: String? = nil
    private var secondaryAction: (() -> Void)? = nil
    
    func setTitle(_ title: String) -> AlertBuilder { self.title = title; return self }
    func setMessage(_ message: String) -> AlertBuilder { self.message = message; return self }
    func setPrimaryButton(_ title: String, action: (() -> Void)? = nil) -> AlertBuilder {
        self.primaryTitle = title; self.primaryAction = action; return self
    }
    func setSecondaryButton(_ title: String, action: (() -> Void)? = nil) -> AlertBuilder {
        self.secondaryTitle = title; self.secondaryAction = action; return self
    }
    
    func build() -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: primaryTitle, style: .default) { _ in self.primaryAction?() })
        if let secondaryTitle = secondaryTitle {
            alert.addAction(UIAlertAction(title: secondaryTitle, style: .cancel) { _ in self.secondaryAction?() })
        }
        return alert
    }
}
