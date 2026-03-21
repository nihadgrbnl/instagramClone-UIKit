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
    weak var parentCoordinator: AppCoordinator?
    
    private var feedNav: UINavigationController?
    private var searchNav: UINavigationController?
    private var uploadNav: UINavigationController?
    private var dmNav: UINavigationController?
    private var profileNav: UINavigationController?
    
    init() {
        self.navigationController = UINavigationController()
        self.tabBarController = MainTabBarController()
    }
    
    func start() {
        let feedController = FeedController()
        feedNav = makeNav(root: feedController, title: "Home", image: "house", selectedImage: "house.fill")
//        feedController.coordinator = self

        let searchController = SearchController()
        searchNav = makeNav(root: searchController, title: "Search", image: "magnifyingglass", selectedImage: "magnifyingglass")
//        searchController.coordinator = self

        let uploadController = UploadController()
        uploadNav = makeNav(root: uploadController, title: "", image: "plus.app", selectedImage: "plus.app.fill")
//        uploadController.coordinator = self

        let dmController = DMInboxController()
        dmNav = makeNav(root: dmController, title: "Messages", image: "message", selectedImage: "message.fill")
        dmController.coordinator = self

        let profileController = ProfileController()
        profileNav = makeNav(root: profileController, title: "Profile", image: "person.circle", selectedImage: "person.circle.fill")
//        profileController.coordinator = self

        tabBarController.viewControllers = [feedNav, searchNav, uploadNav, dmNav, profileNav].compactMap{ $0 }
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
        guard let otherUserID = message.id else { return }
        let chatController = ChatViewController(otherUserID: otherUserID)
        chatController.coordinator = self
        dmNav?.show(chatController, sender: nil)
    }
    
    func didLogOut() {
        let repo = FirebaseAuthRepository()
        repo.logout()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        parentCoordinator?.didLogOut()
    }
    
    func goBack() {
        dmNav?.popViewController(animated: true)
    }
}
