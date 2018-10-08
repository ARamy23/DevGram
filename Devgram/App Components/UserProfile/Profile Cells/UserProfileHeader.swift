//
//  UserProfileHeader.swift
//  Devgram
//
//  Created by ScaRiLiX on 9/30/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol ViewTypeDelegate: class
{
    func didChangeViewType(to viewType: UserProfileHeader.ViewType)
}

class UserProfileHeader: UICollectionViewCell
{
    //MARK:- Instance Vars
    
    var user: User?
    {
        didSet
        {
            guard let user = user else { return }
            if let imageURL = user.profileImageURL
            {
                profileImageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "user-placeholder"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
            }
            usernameLabel.text = user.username
            if user.uid == FirebaseService.currentUserUID { userType = .currentUser }
            else if user.uid != FirebaseService.currentUserUID { userType = .anotherUser }
        }
    }
    
    weak var delegate: ViewTypeDelegate?
    
    //MARK:- Helpers
    
    enum UserType
    {
        case currentUser
        case anotherUser
    }
    
    var userType: UserType?
    {
        didSet
        {
            setUI(accordingTo: userType)
        }
    }
    
    enum ViewType
    {
        case gridView
        case listView
    }
    
    var viewType: ViewType = .gridView
    {
        didSet
        {
            setView(accordingTo: viewType)
            delegate?.didChangeViewType(to: viewType)
        }
    }
    
    var isFollowed: Bool = false
    
    var postsCount = 0
    {
        didSet
        {
            let attributedText = NSMutableAttributedString(string: "\(postsCount)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "Posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            postsLabel.attributedText = attributedText
        }
    }
    
    //MARK:- UI Initialization
    
    let profileImageView: UIImageView =
    {
        let iv = UIImageView()
        iv.layer.cornerRadius = 40
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "user-placeholder")
        return iv
    }()
    
    lazy var gridButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        btn.tintColor = .appPrimaryColor
        btn.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return btn
    }()
    
    lazy var listButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        btn.tintColor = .switchedOffButtonColor
        btn.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return btn
    }()
    
    lazy var bookmarkButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        btn.tintColor = .switchedOffButtonColor
        return btn
    }()
    
    let usernameLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    
    let followersLabel: UILabel =
    {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    
    let followingLabel: UILabel =
    {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    lazy var editProfileButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(handleProfileAction), for: .touchUpInside)
        return btn
    }()
    
    //MARK:- Setup Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProfileImage()
        setupBottomToolbar()
        setupUsername()
        setupUserStats()
        setupEditButton()
    }
    
    fileprivate func setupEditButton()
    {
        addSubview(editProfileButton)
        
        editProfileButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(postsLabel.snp.bottom).inset(-8)
            maker.left.equalTo(profileImageView.snp.right).inset(-12)
            maker.right.equalTo(followingLabel).inset(12)
            maker.height.equalTo(34)
        }
    }
    
    fileprivate func setupUserStats()
    {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel], axis: .horizontal, spacing: 0, alignment: .fill, distribution: .fillEqually)
        addSubview(stackView)
        
        stackView.snp.makeConstraints { (maker) in
            maker.top.right.equalTo(self).inset(12)
            maker.left.equalTo(profileImageView.snp.right).inset(12)
            maker.height.equalTo(50)
        }
        
        let attributedText = NSMutableAttributedString(string: "\(postsCount)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        postsLabel.attributedText = attributedText
    }
    
    fileprivate func setupUsername()
    {
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(profileImageView.snp.bottom).inset(4)
            maker.left.right.equalTo(self).inset(12)
            maker.bottom.equalTo(gridButton.snp.top)
        }
    }
    
    fileprivate func setupProfileImage()
    {
        addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { (maker) in
            maker.top.left.equalTo(self).inset(12)
            maker.width.height.equalTo(80)
        }
    }
    
    fileprivate func setupBottomToolbar()
    {
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton], axis: .horizontal, spacing: 10, alignment: .fill, distribution: .fillEqually)
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.snp.makeConstraints { (maker) in
            maker.left.bottom.right.equalTo(self.contentView)
            maker.height.equalTo(50)
        }
        
        topDividerView.snp.makeConstraints { (maker) in
            maker.top.right.left.equalTo(stackView)
            maker.height.equalTo(0.5)
        }
        
        bottomDividerView.snp.makeConstraints { (maker) in
            maker.bottom.right.left.equalTo(stackView)
            maker.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Logic
    
    fileprivate func configureViewButtons(accordingTo viewType: ViewType)
    {
        UIView.animate(withDuration: 0.4)
        {
            [weak self] in
            switch viewType
            {
            case .gridView:
                self?.gridButton.tintColor = .appPrimaryColor
                self?.listButton.tintColor = .switchedOffButtonColor
                self?.bookmarkButton.tintColor = .switchedOffButtonColor
            case .listView:
                self?.gridButton.tintColor = .switchedOffButtonColor
                self?.listButton.tintColor = .appPrimaryColor
                self?.bookmarkButton.tintColor = .switchedOffButtonColor
            }
        }
    }
    
    fileprivate func setView(accordingTo viewType: ViewType)
    {
        configureViewButtons(accordingTo: viewType)
    }
    
    @objc fileprivate func handleChangeToGridView()
    {
        self.viewType = .gridView
    }
    
    @objc fileprivate func handleChangeToListView()
    {
        self.viewType = .listView
    }
    
    fileprivate func editProfile()
    {
        //TODO:
    }
    
    fileprivate func configureFollowStatus()
    {
        if isFollowed
        {
            
            editProfileButton.setTitle("Unfollow", for: .normal)
            editProfileButton.backgroundColor = .appForthColor
            editProfileButton.setTitleColor(.black, for: .normal)
            editProfileButton.layer.borderColor = UIColor.lightGray.cgColor
        }
        else
        {
            editProfileButton.setTitle("Follow", for: .normal)
            editProfileButton.backgroundColor = .appPrimaryColor
            editProfileButton.setTitleColor(.white, for: .normal)
            editProfileButton.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    fileprivate func unfollow()
    {
        guard let uid = user?.uid else { return }
        SVProgressHUD.show()
        FirebaseService.databaseFollowingsRef.child(uid).updateChildValues([uid: 0]) { (err, _) in
            if err != nil
            {
                print(err!)
                SVProgressHUD.showError(withStatus: err!.localizedDescription)
            }
            
            SVProgressHUD.dismiss()
            DispatchQueue.main.async
            {
                self.isFollowed = false
                self.configureFollowStatus()
            }
        }
    }
    
    fileprivate func follow()
    {
        guard let currentLoggedInUid = FirebaseService.currentUserUID else { return }
        guard let anotherUserId = user?.uid else { return }
        SVProgressHUD.show()
        FirebaseService.databaseFollowingsRef.child(currentLoggedInUid).updateChildValues([anotherUserId: 1]) { (err, _) in
            if err != nil
            {
                print(err!)
                SVProgressHUD.showError(withStatus: err!.localizedDescription)
            }
            
            SVProgressHUD.dismiss()
            DispatchQueue.main.async
            {
                self.isFollowed = true
                self.configureFollowStatus()
            }
        }
    }
    
    fileprivate func checkIfFollowing(_ onCompletion: @escaping (Bool) -> ())
    {
        SVProgressHUD.show()
        guard let uid = user?.uid else { return }
        FirebaseService.databaseFollowingsRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            SVProgressHUD.dismiss()
            guard let followingDictionary = snapshot.value as? [String: Any] else { onCompletion(false); return; }
            if let value = followingDictionary.values.first as? Int { onCompletion(value == 1) }
            else { onCompletion(false) }
        }) { (err) in
            print(err)
            SVProgressHUD.showError(withStatus: err.localizedDescription)
            onCompletion(false)
        }
    }
    
    fileprivate func handleFollowingUser()
    {
        checkIfFollowing { (isFollowing) in
            self.isFollowed = isFollowing
            if isFollowing { self.unfollow() }
            else { self.follow() }
        }
    }
    
    @objc fileprivate func handleProfileAction()
    {
        switch userType
        {
        case .currentUser?:
            editProfile()
        case .anotherUser?:
            handleFollowingUser()
        case .none:
            break
        }
    }
    
    fileprivate func setUI(accordingTo userType: UserType?)
    {
        configureEditButton(accordingTo: userType)
    }
    
    fileprivate func configureEditButton(accordingTo userType: UserType?)
    {
        switch userType
        {
        case .currentUser?:
            editProfileButton.setTitle("Edit Profile", for: .normal)
            editProfileButton.backgroundColor = .appForthColor
            editProfileButton.setTitleColor(.black, for: .normal)
            editProfileButton.layer.borderColor = UIColor.lightGray.cgColor
            
        case .anotherUser?:
            configureFollowStatus()
            checkIfFollowing { (isFollowing) in
                self.isFollowed = isFollowing
                self.configureFollowStatus()
            }
        case .none:
            break
        }
    }
    
}
