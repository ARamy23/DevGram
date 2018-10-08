//
//  PhotoCollectionCell.swift
//  Devgram
//
//  Created by ScaRiLiX on 10/1/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {
    
    let photoImageView: UIImageView =
    {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK:- Initialization
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupPhotoImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupPhotoImageView()
    {
        addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self)
        }
    }
}
