//
//  MainTabBarController.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/15/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {
    
    //MARK: - Properties

    var user: User?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        logOutUsr()
        self.authenticateUserAndConfUI()

    }
    
    
    //MARK: - Helpers
    
    func authenticateUserAndConfUI() {
        
        //           if Auth.auth().currentUser == nil {
        //                   DispatchQueue.main.async {
        //                   let nav = UINavigationController(rootViewController: LoginController())
        //                   nav.modalPresentationStyle = .fullScreen
        //                   self.present(nav, animated: true)
        //               }
        //           }
        configureViewControllers()
        configureUI()
        //               fetchUser()
        
    }
    
    fileprivate func logOutUsr()  {
        do {
            try Auth.auth().signOut()
            print("DEBUG: Successfully signed out")

        } catch {
            print("DEBUG: Error:\(error)")
        }
    }

    func configureUI() {
        navigationController?.navigationBar.barStyle = .default
        view.backgroundColor = .fwDarkBlueBg
        tabBar.barTintColor = .white
        tabBar.tintColor = .black
        tabBar.barStyle = .default
        
    }

    
    func configureViewControllers() {
        let feedNav = embedInNav(image: #imageLiteral(resourceName: "feedicon"), viewController: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))
//        let favoriteNav = embedInNav(image: #imageLiteral(resourceName: "favoriteicon"), viewController: FavoritesController())
        let assetNav = embedInNav(image: #imageLiteral(resourceName: "assetmanagericon"), viewController: AssetManagerController())
        let messagesNav = embedInNav(image: #imageLiteral(resourceName: "messagesicon"), viewController: MessagesController())

        let profileNav = embedInNav(image: #imageLiteral(resourceName: "profileicon"), viewController: ProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        viewControllers = [feedNav, assetNav, messagesNav, profileNav]
    }
    
    func embedInNav(image: UIImage?, viewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.image = image
        nav.navigationBar.tintColor = .white
        nav.navigationBar.barTintColor = .fwDarkNavBar
        nav.navigationBar.barStyle = .black
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.gothamBold(ofSize: 16)]
        return nav
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    

    
    //MARK: - Selectors

}

