//
//  AppCoordinator.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 12.03.26.
//

import Foundation
import UIKit
import FirebaseAuth

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        
        if Auth.auth().currentUser != nil {
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
        mainCoordinator.parentCoordinator = self
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
