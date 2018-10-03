//
//  HomePostCell.swift
//  Devgram
//
//  Created by ScaRiLiX on 10/2/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
    
    //MARK:- Datasource
    
    var post: Post?
    {
        didSet
        {
            
            photoImageView.kf.setImage(with: post?.postImageURL?.url, placeholder: #imageLiteral(resourceName: "placeholder image"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
            usernameLabel.text = post?.user?.username
            userProfileImageView.kf.setImage(with: post?.user?.profileImageURL, placeholder: #imageLiteral(resourceName: "user-placeholder"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
            setupCaptionText()
        }
    }
    
    //MARK:- UI Initialization
    
    let photoImageView: UIImageView =
    {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let userProfileImageView: UIImageView =
    {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    let usernameLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let optionsButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setTitle("•••", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    let actionButtonsStackView: UIStackView =
    {
       let stackView = UIStackView()
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let likeButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "like_unselected").original, for: .normal)
        return btn
    }()
    
    let commentButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "comment").original, for: .normal)
        return btn
    }()
    
    let sendButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "send2").original, for: .normal)
        return btn
    }()
    
    let ribbonButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "ribbon").original, for: .normal)
        return btn
    }()
    
    let captionLabel: UILabel =
    {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    //MARK:- Initialization Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupCaptionText()
    {
        
        let attributedText = NSMutableAttributedString(string: "\(post?.user?.username ?? "Me")", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: ": \(post?.caption ?? "Failed to get Caption" )", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSAttributedString(string: "Some time ago", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        captionLabel.attributedText = attributedText
    }
    
    fileprivate func setupUI()
    {
        addSubview(usernameLabel)
        addSubview(userProfileImageView)
        addSubview(photoImageView)
        addSubview(optionsButton)
        addSubview(actionButtonsStackView)
        addSubview(captionLabel)
        
        setupUserProfileImageView()
        setupUsernameLabel()
        setupPhotoImageView()
        setupOptionsButton()
        setupActionButtons()
        setupCaptionLabel()
    }
    
    fileprivate func setupCaptionLabel()
    {
        captionLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(likeButton.snp.bottom)
            maker.left.right.equalTo(self).inset(8)
            maker.bottom.equalTo(self)
        }
    }
    
    fileprivate func setupActionButtons()
    {
        actionButtonsStackView.addArrangedSubview(likeButton)
        actionButtonsStackView.addArrangedSubview(commentButton)
        actionButtonsStackView.addArrangedSubview(sendButton)
        
        addSubview(ribbonButton)
        
        
        actionButtonsStackView.snp.makeConstraints { (maker) in
            maker.top.equalTo(photoImageView.snp.bottom)
            maker.left.equalTo(self).inset(8)
            maker.width.equalTo(150)
            maker.height.equalTo(50)
        }
        
        ribbonButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(photoImageView.snp.bottom)
            maker.right.equalTo(self)
            maker.size.equalTo(50)
            
        }
    }
    
    fileprivate func setupOptionsButton()
    {
        optionsButton.snp.makeConstraints { (maker) in
            maker.top.right.equalTo(self)
            maker.bottom.equalTo(photoImageView.snp.top)
            maker.width.equalTo(44)
        }
    }
    
    fileprivate func setupUsernameLabel()
    {
        usernameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self)
            maker.right.equalTo(optionsButton.snp.left)
            maker.left.equalTo(userProfileImageView.snp.right).offset(8)
            maker.bottom.equalTo(photoImageView.snp.top)
        }
    }
    
    fileprivate func setupUserProfileImageView()
    {
        userProfileImageView.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self).inset(8)
            maker.size.equalTo(40)
        }
    }
    
    fileprivate func setupPhotoImageView()
    {
        photoImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(userProfileImageView.snp.bottom).offset(8)
            maker.left.right.equalTo(self)
            maker.height.equalTo(self.snp.width)
        }
    }
}
