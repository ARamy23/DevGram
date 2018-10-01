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
    //MARK:- View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentUser()
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupCollectionView() {
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: UserProfileHeader.self)
        collectionView.register(cellWithClass: UICollectionViewCell.self)
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
    
    fileprivate func getCurrentUser()
    {
        guard let uid = FirebaseService.currentUserUID else { return }
        FirebaseService.databaseUsersRef.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.value)
            if let userDictionary = snapshot.value as? [String: Any]
            {
                let user = User(userDictionary)
                self.navigationItem.title = user.username
                FirebaseService.currentUser = user
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK:- Logic
    
    @objc fileprivate func showSettingsActionSheet()
    {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            do
            {
                try Auth.auth().signOut()
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
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: UICollectionViewCell.self, for: indexPath)
        cell.backgroundColor = .appPrimaryColor
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
