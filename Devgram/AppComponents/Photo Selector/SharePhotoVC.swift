//
//  SharePhotoVC.swift
//  Devgram
//
//  Created by ScaRiLiX on 10/2/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import SVProgressHUD

class SharePhotoVC: UIViewController {

    //MARK:- UI Initialization
    let containerView = UIView()
    
    let imageView: UIImageView =
    {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView =
    {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        
        return tv
    }()
    
    //MARK:- View Controller Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        setupContainerView()
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupView()
    {
        view.backgroundColor = .lightGray
    }
    
    fileprivate func setupNavBar()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleSharing))
    }
    
    fileprivate func setupContainerView()
    {
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.left.right.equalTo(view)
            maker.height.equalTo(100)
        }
        setupSelectedImageImageView()
        setupTextView()
    }
    
    fileprivate func setupTextView()
    {
        containerView.addSubview(textView)
        
        textView.snp.makeConstraints { (maker) in
            maker.top.right.bottom.equalTo(containerView).inset(8)
            maker.left.equalTo(imageView.snp.right).offset(4)
        }
    }
    
    fileprivate func setupSelectedImageImageView()
    {
        containerView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (maker) in
            maker.top.left.bottom.equalTo(containerView).inset(8)
            maker.width.equalTo(84)
        }
    }
    
    //MARK:- Logic
    
    @objc fileprivate func handleSharing()
    {
        guard let selectedImage = imageView.image else { return }
        guard let caption = self.textView.text, caption.count > 0 else { return }
        
        store(selectedImage)
        { (url) in
            guard let imageURL = url else { return }
            self.saveToDatabase(with: imageURL, and: caption)
        }
    }
    
    //MARK:- Networking Methods
    
    fileprivate func saveToDatabase(with downloadURL: URL, and caption: String)
    {
        guard let selectedImage = imageView.image else { return }
        guard let uid = FirebaseService.currentUserUID else { return }
        let values: [String: Any] = ["imageURL": downloadURL.absoluteString,
                      "caption": caption,
                      "imageWidth": selectedImage.size.width,
                      "imageHeight": selectedImage.size.height,
                      "creationDate": Date().timeIntervalSince1970]
        FirebaseService.databasePostsRef.child(uid).childByAutoId().updateChildValues(values) { (err, ref) in
            if err != nil
            {
                print(err!)
                SVProgressHUD.showError(withStatus: err!.localizedDescription)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: .updateFeed, object: nil)
        }
    }
    
    fileprivate func store(_ selectedImage: UIImage,_ onCompletion: @escaping (URL?) -> ())
    {
        guard let uploadData = selectedImage.compressedData(quality: 0.5) else { return }
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let filename = UUID().uuidString
        let uploadTask = FirebaseService.storagePostsImagesRef.child(filename).putData(uploadData, metadata: nil) { (metadata, err) in
            if err != nil
            {
                print(err!)
                SVProgressHUD.showError(withStatus: err!.localizedDescription)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            onCompletion(metadata?.downloadURL())
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            SVProgressHUD.showProgress(snapshot.progress?.fractionCompleted.float ?? 1.0)
            
            if snapshot.progress?.isFinished ?? false { SVProgressHUD.dismiss() }
        }
    }
}
