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
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshPosts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.dismiss()
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFeedUpdating), name: .updateFeed, object: nil)
    }
    
    fileprivate func setupRefreshControl()
    {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
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
    
    @objc fileprivate func handleFeedUpdating()
    {
        refreshPosts()
    }
    
    fileprivate func orderPosts()
    {
        posts.sort { (p1, p2) -> Bool in
            guard let date1 = p1.creationDate, let date2 = p2.creationDate else { return false }
            return date1 > date2
        }
    }
    
    fileprivate func estimateFrameFor(text: String) -> CGRect
    {
        let size = CGSize(width: view.width, height: 1000)
        return NSString(string: text).boundingRect(with: size,
                                                   options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
                                                   attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)],
                                                   context: nil)
    }
    
    //MARK:- Networking
    
    @objc fileprivate func refreshPosts()
    {
        posts.removeAll()
        fetchCurrentUsersPosts()
        getFollowedUsersPosts()
    }
    
    fileprivate func getPostsOf(_ user: (User?)) {
        guard let uid = user?.uid else { return }
        FirebaseService.databasePostsRef.child(uid).observe(.value, with: { (snapshot) in
            guard let postsDictionary = snapshot.value as? [String: Any] else {
                return
                
            }
            postsDictionary.forEach({ (_, value) in
                guard let postDictionary = value as? [String: Any] else {
                    return
                }
                
                let post = Post(user: user, postDictionary)
                self.posts.insert(post, at: 0)
            })
            self.orderPosts()
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }) { (err) in
            print(err)
            SVProgressHUD.showError(withStatus: err.localizedDescription)
        }
    }
    
    fileprivate func fetchCurrentUsersPosts()
    {
        FirebaseService.getCurrentUser { (currentUser) in
            self.getPostsOf(currentUser)
        }
    }
    
    fileprivate func getFollowedUsersPosts()
    {
        // get followings list
        guard let uid = FirebaseService.currentUserUID else { return }
        FirebaseService.databaseFollowingsRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let uidsDictionary = snapshot.value as? [String: Any] else { return }
            uidsDictionary.forEach({ (key, value) in
                //get users then get their posts
                guard let isFollowingInt = value as? Int else { return }
                if isFollowingInt == 1
                {
                    FirebaseService.getUser(with: key) { (user) in
                        self.getPostsOf(user)
                    }
                }
            })
        }) { (err) in
            print(err)
            SVProgressHUD.showError(withStatus: err.localizedDescription)
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
