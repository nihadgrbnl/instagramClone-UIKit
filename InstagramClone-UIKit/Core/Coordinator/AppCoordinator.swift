//
//  AppCoordinator.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 12.03.26.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }
    
    private func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.parentCoordinator = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showMainFlow() {
        let mainCoordinator = MainCoordinator()
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
        
        window.rootViewController = mainCoordinator.tabBarController
        window.makeKeyAndVisible()
    }
    
    func didLogOut() {
        childCoordinators.removeAll()
        showAuthFlow()
    }
    
    func didLogin() {
        childCoordinators.removeAll()
        showMainFlow()
    }
    
    
}
