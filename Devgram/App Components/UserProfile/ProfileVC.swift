//
//  ProfileVC.swift
//  Devgram
//
//  Created by ScaRiLiX on 9/30/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import Firebase
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
            self.paginatePosts()
            self.collectionView.reloadData()
        }
    }
    
    //MARK:- Helper vars
    
    var isGridView = true
    {
        didSet
        {
            collectionView.reloadData()
        }
    }
    
    var isFinishedPaging = false
    
    //MARK:- View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if user == nil {
            print(FirebaseService.currentUserUID ?? "No Logged In User")
            if FirebaseService.currentUser != nil
            {
                self.user = FirebaseService.currentUser
            }
            else
            {
                FirebaseService.getCurrentUser { self.user = $0 }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = nil
        SVProgressHUD.dismiss()
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupCollectionView() {
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: UserProfileHeader.self)
        collectionView.register(cellWithClass: ProfilePostImageCell.self)
        collectionView.register(cellWithClass: HomePostCell.self)
        collectionView.backgroundColor = .white
    }
    
    fileprivate func setupGearButton()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(showSettingsActionSheet))
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = user?.username ?? "My Profile"
        setupGearButton()
    }
    
    fileprivate func setupUI()
    {
        setupCollectionView()
        setupNavBar()
    }
    
    //MARK:- Networking Methods
    
    fileprivate func paginatePosts()
    {
        guard let uid = user?.uid else { return }
        let ref = FirebaseService.databasePostsRef.child(uid)
        var query = ref.queryOrdered(byChild: "creationDate")
        
        if posts.count > 0 { query = query.queryEnding(atValue: posts.last?.creationDate?.timeIntervalSince1970) }
        
        query.queryLimited(toLast: 9).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            if self.posts.count > 0 && allObjects.count > 0 { allObjects.removeFirst() }
            
            if allObjects.count < 9 { self.isFinishedPaging = true }
            
            allObjects.forEach({ (snapshot) in
                guard let postDictionary = snapshot.value as? [String: Any] else { return }
                let post = Post(user: self.user, postDictionary)
                self.posts.append(post)
            })
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
        header.user = user
        header.delegate = self
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
        if indexPath.item == posts.count - 1 && !isFinishedPaging
        {
            paginatePosts()
        }
        if isGridView
        {
            let cell = collectionView.dequeueReusableCell(withClass: ProfilePostImageCell.self, for: indexPath)
            let post = posts[indexPath.item]
            cell.post = post
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withClass: HomePostCell.self, for: indexPath)
            let post = posts[indexPath.item]
            cell.post = post
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isGridView { return CGSize(width: (self.view.width - 2) / 3, height: self.view.width / 3) }
        else if let post = posts.item(at: indexPath.item)
        {
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
        
        return CGSize.zero
    }
    
    fileprivate func estimateFrameFor(text: String) -> CGRect
    {
        let size = CGSize(width: view.width, height: 1000)
        return NSString(string: text).boundingRect(with: size, options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
}

extension ProfileVC: ViewTypeDelegate
{
    func didChangeViewType(to viewType: UserProfileHeader.ViewType)
    {
        switch viewType
        {
        case .gridView:
            isGridView = true
        case .listView:
            isGridView = false
        }
    }
}

extension ProfileVC: HomePostDelegate
{
    func didTapOnCommentButton(for post: Post)
    {
        let commentsVC = CommentsVC(collectionViewLayout: UICollectionViewFlowLayout())
        commentsVC.post = post
        navigationController?.pushViewController(commentsVC)
    }
    
    func didTapOnLikeButton(for cell: HomePostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.item]
        guard let postId = post.id else { return }
        guard let uid = FirebaseService.currentUserUID else { return }
        let values: [String: Any] = [uid: post.hasLiked ? 0 : 1]
        FirebaseService.databaseLikesRef.child(postId).updateChildValues(values) { (err, _) in
            if err != nil
            {
                print(err!)
                SVProgressHUD.showError(withStatus: err!.localizedDescription)
                return
            }
            
            post.hasLiked = !post.hasLiked
            
            self.posts[indexPath.item] = post
            
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}
