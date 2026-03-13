//
//  MainTabBarController.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 11.03.26.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    private func configureTabBar () {
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = UIColor(resource: .igPurple)
        tabBar.unselectedItemTintColor = UIColor(resource: .igText)
        
        let border = UIView()
        border.backgroundColor = UIColor(resource: .igBorder)
        border.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(border)
        
        NSLayoutConstraint.activate([
            border.topAnchor.constraint(equalTo: tabBar.topAnchor),
            border.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            border.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
