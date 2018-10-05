//
//  CommentsVC.swift
//  Devgram
//
//  Created by ScaRiLiX on 10/4/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import SVProgressHUD

class CommentsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //MARK:- Datasource
    
    var post: Post?
    var comments = [Comment]()
    
    //MARK:- UI Init
    
    lazy var commentTextField: UITextField =
    {
        let textField = UITextField()
        textField.placeholder = "Enter a comment..."
        return textField
    }()
    
    lazy var containerView: UIView =
    {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmittingComment), for: .touchUpInside)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        containerView.addSubview(commentTextField)
        containerView.addSubview(submitButton)
        containerView.addSubview(seperatorView)
        
        submitButton.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(containerView)
            maker.right.equalTo(containerView).inset(12)
            maker.width.equalTo(50)
        }
        
        commentTextField.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(containerView)
            maker.left.equalTo(containerView).inset(12)
            maker.right.equalTo(submitButton.snp.left)
        }
        
        seperatorView.snp.makeConstraints({ (maker) in
            maker.left.top.right.equalTo(containerView)
            maker.height.equalTo(0.5)
        })
        
        return containerView
    }()
    
    //MARK:- View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        fetchComments()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- View Controller Properties
    
    override var inputAccessoryView: UIView?
    {
        get
        {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool
    {
        return true
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupCollectionView()
    {
        collectionView.backgroundColor = .white
        collectionView.register(cellWithClass: CommentsCell.self)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
    
    fileprivate func setupNavBar()
    {
        navigationItem.title = "Comments"
    }
    
    //MARK:- Networking
    
    fileprivate func fetchComments()
    {
        comments.removeAll()
        guard let postId = post?.id else { return }
        FirebaseService.databaseCommentsRef.child(postId).observe(.childAdded, with: { (snapshot) in
            guard let commentDictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = commentDictionary["uid"] as? String else { return }
            
            FirebaseService.getUser(with: uid, { (user) in
                guard let user = user else { return }
                let comment = Comment(user, commentDictionary)
                self.comments.append(comment)
                self.collectionView.reloadData()
            })
            
        }) { (err) in
            print(err)
            SVProgressHUD.showError(withStatus: err.localizedDescription)
        }
    }
    
    //MARK:- Logic
    
    @objc fileprivate func handleSubmittingComment()
    {
        guard let postID = post?.id else { return }
        guard let commentText = commentTextField.text else { return }
        guard let uid = FirebaseService.currentUserUID else { return }
        
        let values: [String: Any] = ["text": commentText,
                                     "creationDate": Date().timeIntervalSince1970,
                                     "uid": uid]
        FirebaseService.databaseCommentsRef.child(postID).childByAutoId().updateChildValues(values) { (err, _) in
            if err != nil
            {
                print(err!)
                SVProgressHUD.showError(withStatus: err!.localizedDescription)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return comments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CommentsCell.self, for: indexPath)
        let comment = comments[indexPath.item]
        cell.comment = comment
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let comment = comments[indexPath.item]
        
        let estimatedHeight = estimateFrameFor(text: comment.text ?? "").height + 32
        let height = max(40 + 8 + 8, estimatedHeight)
        
        return CGSize(width: view.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 4
    }
    
    fileprivate func estimateFrameFor(text: String) -> CGRect
    {
        let size = CGSize(width: view.width, height: 1000)
        return NSString(string: text).boundingRect(with: size,
                                                   options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin),
                                                   attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)],
                                                   context: nil)
    }
}
