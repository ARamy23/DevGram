//
//  MainTabBarController.swift
//  Devgram
//
//  Created by ScaRiLiX on 9/30/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    //MARK:- View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async { self.checkIfUserIsLoggedIn() }
        setupTabBarUI()
        setupVCs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { self.checkIfUserIsLoggedIn() }
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupTabBarUI()
    {
        view.backgroundColor = .white
        tabBar.tintColor = .appPrimaryColor
    }
    
    fileprivate func setupVCs()
    {
        viewControllers = [
            generateNavCon(viewController: ProfileVC(collectionViewLayout: UICollectionViewFlowLayout()), name: "My Profile", image: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"))
        ]
    }
    
    //MARK:- Helper Methods
    
    fileprivate func generateNavCon(viewController: UIViewController,name: String? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil) -> UIViewController
    {
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.navigationBar.topItem?.title = title
        navVC.tabBarItem.title = title
        navVC.tabBarItem.image = image
        navVC.tabBarItem.selectedImage = selectedImage ?? image
        navVC.navigationBar.tintColor = #colorLiteral(red: 0.4235294118, green: 0.4274509804, blue: 0.7921568627, alpha: 1)
        return navVC
    }
    
    //MARK:- Logic
    
    fileprivate func checkIfUserIsLoggedIn()
    {
        if FirebaseService.currentUserUID == nil
        {
            present(generateNavCon(viewController: LoginVC()), animated: true, completion: nil)
        }
    }
}
