//
//  PhotoPreviewContainerView.swift
//  Devgram
//
//  Created by ScaRiLiX on 10/4/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD

protocol SharingPhotoDelegate: class
{
    func didSelectSharing(_ previewImage: UIImage)
}

class PhotoPreviewContainerView: UIView {

    //MARK:- UI Init Methods
    
    let previewImageView: UIImageView =
    {
        let iv = UIImageView()
        return iv
    }()
    
    let whiteAnimationView: UIView =
    {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let cancelButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "cancel_shadow").original, for: .normal)
        btn.addTarget(self, action: #selector(handleCanceling), for: .touchUpInside)
        return btn
    }()
    
    let saveButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "save_shadow").original, for: .normal)
        btn.addTarget(self, action: #selector(handleSaving), for: .touchUpInside)
        return btn
    }()
    
    let shareButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "telegram").original, for: .normal)
        btn.addTarget(self, action: #selector(handleSharing), for: .touchUpInside)
        return btn
    }()
    
    //MARK:- Instance Vars
    
    weak var delegate: SharingPhotoDelegate?
    
    //MARK:- View Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupUI()
    {
        addSubview(previewImageView)
        addSubview(whiteAnimationView)
        addSubview(cancelButton)
        addSubview(saveButton)
        addSubview(shareButton)
        
        setupPreviewImageView()
        setupWhiteAnimationView()
        setupCancelButton()
        setupSaveButton()
        setupShareButton()
    }
    
    fileprivate func setupPreviewImageView()
    {
        previewImageView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self)
        }
    }
    
    fileprivate func setupWhiteAnimationView()
    {
        whiteAnimationView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.whiteAnimationView.alpha = 0
        }
    }
    
    fileprivate func setupCancelButton()
    {
        cancelButton.snp.makeConstraints { (maker) in
            maker.top.left.equalTo(self).inset(24)
        }
    }
    
    fileprivate func setupSaveButton()
    {
        saveButton.snp.makeConstraints { (maker) in
            maker.bottom.left.equalTo(self).inset(24)
        }
    }
    
    fileprivate func setupShareButton()
    {
        shareButton.snp.makeConstraints { (maker) in
            maker.bottom.right.equalTo(self).inset(24)
            maker.size.equalTo(50)
        }
    }
    
    //MARK:- Logic
    
    @objc fileprivate func handleSharing()
    {
        guard let previewImage = previewImageView.image else { return }
        delegate?.didSelectSharing(previewImage)
    }
    
    @objc fileprivate func handleSaving()
    {
        guard let previewImage = previewImageView.image else { return }
        let library = PHPhotoLibrary.shared()
        
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (isSuccess, err) in
            if err != nil
            {
                print(err!)
                SVProgressHUD.showError(withStatus: err!.localizedDescription)
            }
            
            SVProgressHUD.showSuccess(withStatus: "Saved Photo into Library Successfully!")
        }
    }
    
    @objc fileprivate func handleCanceling()
    {
        self.removeFromSuperview()
    }
    
}
