//
//  SearchResultCell.swift
//  Devgram
//
//  Created by ScaRiLiX on 10/2/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    //MARK:- Datasource
    
    var user: User?
    {
        didSet
        {
            usernameLabel.text = user?.username
            profileImageView.kf.setImage(with: user?.profileImageURL, placeholder: #imageLiteral(resourceName: "user-placeholder"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
        }
    }
    
    //MARK:- UI Initialization
    
    let profileImageView: UIImageView =
    {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.cornerRadius = 25
        iv.image = #imageLiteral(resourceName: "user-placeholder")
        return iv
    }()
    
    let usernameLabel: UILabel =
    {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    //MARK:- Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupUI()
    {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        
        setupProfileImageView()
        setupUsernameLabel()
    }
    
    fileprivate func setupProfileImageView()
    {
        profileImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).inset(8)
            maker.size.equalTo(50)
            maker.centerY.equalTo(self)
        }
    }
    
    fileprivate func setupUsernameLabel()
    {
        usernameLabel.snp.makeConstraints { (maker) in
            maker.top.bottom.right.equalTo(self)
            maker.left.equalTo(profileImageView.snp.right).offset(8)
        }
    }
    
    fileprivate func setupSeperatorView()
    {
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        seperatorView.snp.makeConstraints { (maker) in
            maker.left.equalTo(usernameLabel)
            maker.bottom.right.equalTo(self)
            maker.height.equalTo(0.5)
        }
    }
}
