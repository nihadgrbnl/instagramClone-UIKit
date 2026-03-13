//
//  MainCoordinator.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 12.03.26.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var tabBarController: MainTabBarController
    
    init() {
        self.navigationController = UINavigationController()
        self.tabBarController = MainTabBarController()
    }
    
    func start() {
        let feedController = FeedController()
        let searchController = SearchController()
        let uploadController = UploadController()
        let dmController = DMInboxController()
        let profileController = ProfileController()
        
        let feedNav = makeNav(root: feedController, title: "Home", image: "house", selectedImage: "house.fill")
        let searchNav = makeNav(root: searchController, title: "Search", image: "magnifyingglass", selectedImage: "magnifyingglass")
        let uploadNav = makeNav(root: uploadController, title: "", image: "plus.app", selectedImage: "plus.app.fill")
        let dmNav = makeNav(root: dmController, title: "Messages", image: "message", selectedImage: "message.fill")
        let profileNav = makeNav(root: profileController, title: "Profile", image: "person.circle", selectedImage: "person.circle.fill")
        
        
        tabBarController.viewControllers = [feedNav, searchNav, uploadNav, dmNav, profileNav]
        tabBarController.coordinator = self
    }
    
    private func makeNav(root: UIViewController, title: String, image: String, selectedImage: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: root)
        nav.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: image),
            selectedImage: UIImage(systemName: selectedImage)
        )
        return nav
    }
    
    func goToChat(message: RecentMessages) {
        
    }
    
    func didLogOut() {
        
    }
}
