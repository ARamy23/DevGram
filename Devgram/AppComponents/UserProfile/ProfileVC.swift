//
//  ProfileVC.swift
//  Devgram
//
//  Created by ScaRiLiX on 9/30/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class ProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK:- Datasource
    
    var posts = [Post]()
    
    //MARK:- Instance Vars
    
    var user: User?
    {
        didSet
        {
            self.navigationItem.title = user?.username
            self.collectionView.reloadData()
        }
    }
    
    //MARK:- View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseService.getCurrentUser { self.user = $0 }
        fetchPosts()
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupCollectionView() {
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: UserProfileHeader.self)
        collectionView.register(cellWithClass: ProfilePostImageCell.self)
        collectionView.backgroundColor = .white
    }
    
    fileprivate func setupGearButton()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(showSettingsActionSheet))
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "My Profile"
        setupGearButton()
    }
    
    fileprivate func setupUI()
    {
        setupCollectionView()
        setupNavBar()
    }
    
    //MARK:- Networking Methods
    
    fileprivate func fetchPosts()
    {
        guard let uid = FirebaseService.currentUserUID else { return }
        FirebaseService.databasePostsRef.child(uid).observe(.value, with: { (snapshot) in
            guard let postsDictionary = snapshot.value as? [String: Any] else { return }
            var posts = [Post]()
            postsDictionary.forEach({ (_, value) in
                guard let postDictionary = value as? [String: Any] else { return }
                
                guard let user = self.user else { return }
                
                let post = Post(user: user, postDictionary)
                posts.insert(post, at: 0)
            })
            self.posts = posts
            self.collectionView.reloadData()
        }) { (err) in
            print(err)
            SVProgressHUD.showError(withStatus: err.localizedDescription)
        }
    }
    
    //MARK:- Logic
    
    @objc fileprivate func showSettingsActionSheet()
    {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action) in
            do
            {
                try Auth.auth().signOut()
                DispatchQueue.main.async { UIApplication.mainTabBarController()?.checkIfUserIsLoggedIn() }
            }
            catch let err
            {
                print(err)
                SVProgressHUD.showError(withStatus: err.localizedDescription)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- UICollectionView Methods
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: UserProfileHeader.self, for: indexPath)
        header.user = FirebaseService.currentUser
        header.postsCount = posts.count
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ProfilePostImageCell.self, for: indexPath)
        let post = posts[indexPath.item]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.width - 2) / 3, height: self.view.width / 3)
    }
}
