//
//  HomeVC.swift
//  Devgram
//
//  Created by ScaRiLiX on 10/2/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //MARK:- Datasource
    
    var posts = [Post]()
    
    //MARK:- View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupNavItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupCollectionView()
    {
        collectionView.backgroundColor = .white
        collectionView.register(cellWithClass: HomePostCell.self)
    }
    
    fileprivate func setupNavItems()
    {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo_black"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    //MARK:- Logic
    
    private func estimateFrameFor(text: String) -> CGRect
    {
        let size = CGSize(width: view.width, height: 1000)
        return NSString(string: text).boundingRect(with: size,
                                                   options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
                                                   attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)],
                                                   context: nil)
    }
    
    //MARK:- Networking
    
    fileprivate func getPostsOf(_ user: (User?)) {
        FirebaseService.databaseCurrentUserPostsRef.observe(.value, with: { (snapshot) in
            guard let postsDictionary = snapshot.value as? [String: Any] else { return }
            var posts = [Post]()
            postsDictionary.forEach({ (_, value) in
                guard let postDictionary = value as? [String: Any] else { return }
                
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
    
    fileprivate func fetchPosts()
    {
        FirebaseService.getCurrentUser { (currentUser) in
            self.getPostsOf(currentUser)
        }
    }
    
    //MARK:- UICollectionView Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: HomePostCell.self, for: indexPath)
        let post = posts[indexPath.item]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = posts[indexPath.item]
        
        let profileImageHeight: CGFloat = 40.0
        let usernameLabelHeight: CGFloat = 8.0
        let optionsButtonHeight: CGFloat = 8.0
        let actionButtonsHeight: CGFloat = 50.0
        let photoImageViewHeight: CGFloat = view.width
        let captionHeight: CGFloat = estimateFrameFor(text: post.caption ?? "").height + 32.0
        
        var height = profileImageHeight
        height += usernameLabelHeight
        height += optionsButtonHeight
        height += photoImageViewHeight
        height += actionButtonsHeight
        height += captionHeight
        
        return CGSize(width: view.width, height: height)
    }
}
