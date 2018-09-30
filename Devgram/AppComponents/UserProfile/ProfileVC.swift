//
//  ProfileVC.swift
//  Devgram
//
//  Created by ScaRiLiX on 9/30/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit

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
    
    fileprivate func setupUI()
    {
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: UICollectionReusableView.self)
        collectionView.backgroundColor = .white
        navigationItem.title = "My Profile"
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
            }
        }
    }
    
    //MARK:- UICollectionView Methods
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: UICollectionReusableView.self, for: indexPath)
        
        header.backgroundColor = .green
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 200)
    }
}
