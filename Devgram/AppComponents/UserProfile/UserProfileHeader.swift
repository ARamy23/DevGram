//
//  UserProfileHeader.swift
//  Devgram
//
//  Created by ScaRiLiX on 9/30/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionViewCell
{
    
    var user: User?
    {
        didSet
        {
            if let imageURL = user?.profileImageURL
            {
                profileImageView.download(from: imageURL, contentMode: .scaleAspectFill, placeholder: nil, completionHandler: nil)
            }
            usernameLabel.text = user?.username
        }
    }
    
    //MARK:- UI Initialization
    
    let profileImageView: UIImageView =
    {
        let iv = UIImageView()
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "user-placeholder")
        return iv
    }()
    
    let gridButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        btn.tintColor = .appPrimaryColor
        return btn
    }()
    
    let listButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    
    let bookmarkButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
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
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
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
    
    let editProfileButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4
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
}
