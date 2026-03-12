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
        let feedNav = UINavigationController()
        let searchNav = UINavigationController()
        let uploadNav = UINavigationController()
        let profileNav = UINavigationController()
        let dmNav = UINavigationController()
        
        tabBarController.viewControllers = [feedNav, searchNav, uploadNav, profileNav, dmNav]
//        tabBarController.coordinator = self
    }
    
    func goToChat(user: User) {
        
    }
    
    func didLogOut() {
        
    }
}
