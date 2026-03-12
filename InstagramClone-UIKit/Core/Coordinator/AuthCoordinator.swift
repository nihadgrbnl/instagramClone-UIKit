//
//  AuthCoordinator.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 12.03.26.
//

import Foundation
import UIKit

class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: AppCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginController = LoginViewController()
        loginController.coordinator = self
        navigationController.pushViewController(loginController, animated: true)
    }
    
    func goToRegister() {
        let registerController = RegisterViewController()
        registerController.coordinator = self
        navigationController.pushViewController(registerController, animated: true)
    }
    
    func didLogin() {
        parentCoordinator?.didLogin()
    }
}
