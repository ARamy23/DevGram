//
//  CommentsCell.swift
//  Devgram
//
//  Created by ScaRiLiX on 10/5/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit

class CommentsCell: UICollectionViewCell {
    
    //MARK:- Datasource
    
    var comment: Comment?
    {
        didSet
        {
            guard let comment = self.comment else { return }
            guard let commentText = comment.text else { return }
            guard let username = comment.user.username else { return }
            
            let attributedText = NSMutableAttributedString(string: "\(username): ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string: commentText, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            
            commentTextView.attributedText = attributedText
            profileImageView.kf.setImage(with: comment.user.profileImageURL, placeholder: #imageLiteral(resourceName: "user-placeholder"), options: [.transition(.fade(0.9))], progressBlock: nil, completionHandler: nil)
        }
    }
    
    //MARK:- UI Init
    
    lazy var commentTextView: UITextView =
    {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        return tv
    }()
    
    lazy var profileImageView: UIImageView =
    {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    lazy var bottomSeperatorView: UIView =
    {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1)
        return view
    }()
    
    //MARK:- Cell Init methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Setup methods
    
    fileprivate func setupUI()
    {
        addSubview(profileImageView)
        addSubview(commentTextView)
        addSubview(bottomSeperatorView)
        
        setupTextView()
        setupProfileImageView()
        setupSeperatorView()
    }
    
    fileprivate func setupTextView()
    {
        commentTextView.snp.makeConstraints { (maker) in
            maker.top.right.bottom.equalTo(self).inset(4)
            maker.left.equalTo(profileImageView.snp.right).offset(4)
        }
    }
    
    fileprivate func setupProfileImageView()
    {
        profileImageView.snp.makeConstraints { (maker) in
            maker.top.left.equalTo(self).inset(4)
            maker.size.equalTo(40)
        }
    }
    
    fileprivate func setupSeperatorView()
    {
        bottomSeperatorView.snp.makeConstraints { (maker) in
            maker.left.bottom.right.equalTo(self)
            maker.height.equalTo(0.5)
        }
    }
}
