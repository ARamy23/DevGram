//
//  PostCell.swift
//  Devgram
//
//  Created by ScaRiLiX on 10/2/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import Kingfisher

class ProfilePostImageCell: UICollectionViewCell {
    
    let postImageView: UIImageView =
    {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    var post: Post?
    {
        didSet
        {
            postImageView.kf.setImage(with: post?.postImageURL?.url)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPostImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupPostImageView()
    {
        addSubview(postImageView)
        
        postImageView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self)
        }
    }
}
