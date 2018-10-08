//
//  UserSearchVC.swift
//  Devgram
//
//  Created by ScaRiLiX on 10/2/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserSearchVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //MARK:- Datasource
    
    var users = [User]()
    var filteredUsers = [User]()
    
    //MARK:- Instance Vars
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK:- View Controller Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUsers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.dismiss()
    }

    //MARK:- Setup Methods
    
    fileprivate func setupCollectionView()
    {
        collectionView.backgroundColor = .white
        collectionView.register(cellWithClass: SearchResultCell.self)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
    }
    
    fileprivate func setupNavBar()
    {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Enter a username"
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }

    //MARK:- Networking
    
    fileprivate func fetchUsers()
    {
        SVProgressHUD.show(withStatus: "Fetching Users")
        FirebaseService.databaseUsersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            var users = [User]()
            dictionary.forEach({ (key, value) in
                guard let userDictionary = value as? [String: Any] else { return }
                print(key, userDictionary)
                let user = User(uid: key, userDictionary)
                if key != FirebaseService.currentUserUID { users.append(user) }
            })
            self.users = users
            self.filteredUsers = users
            self.collectionView.reloadData()
            SVProgressHUD.dismiss()
        }) { (err) in
            print(err)
            SVProgressHUD.showError(withStatus: err.localizedDescription)
        }
    }
    
    // MARK:- UICollectionView Methods

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: SearchResultCell.self, for: indexPath)
        let user = filteredUsers[indexPath.item]
        cell.user = user
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.width, height: 66)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchController.searchBar.resignFirstResponder()
        let user = filteredUsers[indexPath.item]
        let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        profileVC.user = user
        navigationController?.pushViewController(profileVC)
    }
}

extension UserSearchVC: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty { filteredUsers = users }
        else { filteredUsers = users.filter { $0.username?.lowercased().contains(searchText.lowercased()) ?? false } }
        collectionView.reloadData()
    }
}
