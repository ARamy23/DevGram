//
//  MainTabBarController.swift
//  Devgram
//
//  Created by ScaRiLiX on 9/30/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import FirebaseAuth
import UIKit

class MainTabBarController: UITabBarController {

    //MARK:- View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async { self.checkIfUserIsLoggedIn() }
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { self.checkIfUserIsLoggedIn() }
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupTabBar()
    {
        view.backgroundColor = .white
        tabBar.tintColor = .appPrimaryColor
        delegate = self
    }
    
    fileprivate func setupVCs()
    {
        viewControllers = [
            generateNavCon(viewController: HomeVC(collectionViewLayout: UICollectionViewFlowLayout()), name: "Home", image: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected")),
            generateNavCon(viewController: UserSearchVC(collectionViewLayout: UICollectionViewFlowLayout()), name: "Search", image: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected")),
            generateNavCon(viewController: UIViewController(), name: "Plus", image: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected")),
            generateNavCon(viewController: UIViewController(), name: "Like", image: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected")),
            generateNavCon(viewController: ProfileVC(collectionViewLayout: UICollectionViewFlowLayout()), name: "My Profile", image: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"))
        ]
    }
    
    func setupUI()
    {
        setupTabBar()
        setupVCs()
        setupTabBarIconsCorrectly()
    }
    
    fileprivate func setupTabBarIconsCorrectly()
    {
        guard let tabBarItems = tabBar.items else { return }
        for item in tabBarItems
        {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    //MARK:- Helper Methods
    
    fileprivate func generateNavCon(viewController: UIViewController,name: String? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil) -> UIViewController
    {
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.navigationBar.topItem?.title = title
        navVC.tabBarItem.title = title
        navVC.tabBarItem.image = image
        navVC.tabBarItem.selectedImage = selectedImage
        navVC.navigationBar.tintColor = .appSecondaryColor
        return navVC
    }
    
    //MARK:- Logic
    
    func checkIfUserIsLoggedIn()
    {
        if Auth.auth().currentUser == nil
        {
            present(generateNavCon(viewController: LoginVC()), animated: true, completion: nil)
        }
    }
}

extension MainTabBarController: UITabBarControllerDelegate
{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        
        if index == 2
        {
            let photoSelectorVC = generateNavCon(viewController: PhotoSelectorVC(collectionViewLayout: UICollectionViewFlowLayout()))
            present(photoSelectorVC, animated: true, completion: nil)
            return false
        }
        
        return true
    }
}