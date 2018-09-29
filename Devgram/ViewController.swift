//
//  ViewController.swift
//  Devgram
//
//  Created by ScaRiLiX on 9/27/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwifterSwift
import SVProgressHUD
import SnapKit

class ViewController: UIViewController {

    //MARK:- UI Elements Initialization
    
    let pickPhotoButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .appPrimaryColor
        button.addTarget(self, action: #selector(handlePickingPhoto), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 3
        return button
    }()
    
    let inputStackView: UIStackView =
    {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    let emailTextField: UITextField =
    {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.textColor = .appSecondaryColor
        tf.attributedPlaceholder = NSAttributedString(string: "JohnDoe@iDevAR.com", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appThirdColor])
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .clear
        tf.layer.borderColor = UIColor.appThirdColor.cgColor
        tf.layer.borderWidth = 4
        tf.layer.cornerRadius = 16
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let userNameTextField: UITextField =
    {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.textColor = .appSecondaryColor
        tf.attributedPlaceholder = NSAttributedString(string: "JohnDoe23", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appThirdColor])
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .clear
        tf.layer.borderColor = UIColor.appThirdColor.cgColor
        tf.layer.borderWidth = 4
        tf.layer.cornerRadius = 16
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField =
    {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.textColor = .appSecondaryColor
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appThirdColor])
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .clear
        tf.layer.borderColor = UIColor.appThirdColor.cgColor
        tf.layer.borderWidth = 4
        tf.layer.cornerRadius = 16
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signupButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .appThirdColor
        button.setTitleColor(.appSecondaryColor, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    //MARK:- View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .appForthColor
        setupUI()
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupUI()
    {
        setupPhotoButton()
        setupInputStackView()
        setupInputViews()
    }
    
    fileprivate func setupPhotoButton()
    {
        view.addSubview(pickPhotoButton)
        
        pickPhotoButton.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(140)
            maker.top.equalTo(view).offset(40)
            maker.centerX.equalTo(view)
        }
    }
    
    fileprivate func setupInputStackView()
    {
        
        view.addSubview(inputStackView)
//
//        inputStackView.anchor(top: pickPhotoButton.bottomAnchor,
//                              left: view.leftAnchor,
//                              right: view.rightAnchor,
//                              bottom: nil,
//                              width: 0,
//                              height: 250,
//                              paddingFromTop: 20,
//                              paddingFromLeft: 40,
//                              paddingFromRight: -40,
//                              paddingFromBottom: 0)
        
        inputStackView.snp.makeConstraints { (maker) in
            maker.height.equalTo(250)
            maker.left.equalToSuperview().inset(40)
            maker.right.equalToSuperview().inset(40)
            maker.top.equalTo(pickPhotoButton.snp.bottom).inset(-20)
        }
    }
    
    fileprivate func setupInputViews()
    {
        inputStackView.addArrangedSubview(emailTextField)
        inputStackView.addArrangedSubview(userNameTextField)
        inputStackView.addArrangedSubview(passwordTextField)
        inputStackView.addArrangedSubview(signupButton)
    }
    
    //MARK:- Logic
    
    @objc fileprivate func handlePickingPhoto()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true , completion: nil)
    }
    
    @objc fileprivate func handleTextInputChange()
    {
        
        UIView.animate(withDuration: 0.5)
        {
            if self.isEmailInputValid(), self.isUsernameValid(), self.isPasswordValid()
            {
                self.signupButton.backgroundColor = .appPrimaryColor
                self.signupButton.isEnabled = true
            }
            else
            {
                self.signupButton.backgroundColor = .appThirdColor
                self.signupButton.isEnabled = false
            }
        }
        
    }
    
    fileprivate func isEmailInputValid() -> Bool
    {
        guard let email = emailTextField.text else { return false }
        
        if !email.isEmpty, email.isValidEmail, email.count > 0
        {
            return true
        }
        else
        {
            SVProgressHUD.showError(withStatus: "Email Not Valid!")
            return false
        }
    }
    
    fileprivate func isUsernameValid() -> Bool {
        
        guard let username = userNameTextField.text else { return false }
        
        if !username.isEmpty, username.isAlphabetic
        {
            return true
        }
        else
        {
            SVProgressHUD.showError(withStatus: "Username Not Valid!")
            return false
        }
    }
    
    fileprivate func isPasswordValid() -> Bool {
        
        guard let password = passwordTextField.text else { return false }
        
        if password.count >= 6
        {
            return true
        }
        else
        {
            SVProgressHUD.showError(withStatus: "Password Not Valid!")
            return false
        }
    }
    
    fileprivate func authenticateCurrentUser()
    {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let username = userNameTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil
            {
                print(error!)
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            
            self.store(self.pickPhotoButton.imageView?.image ?? #imageLiteral(resourceName: "user-placeholder"), onCompletion: { (downloadImageURL) in
                let userValues = ["email": email, "username": username, "profileImageURL": downloadImageURL?.absoluteString]
                let uid = user!.user.uid
                let values = [uid: userValues]
                self.registerCurrentUser(with: values)
            })
            
        }
    }
    
    fileprivate func store(_ image: UIImage, onCompletion: @escaping ((URL?) ->()))
    {
        let fileName = UUID().uuidString
        guard let uploadData = image.jpegData(compressionQuality: 0.1) else { return }
        let profileImageRef = FirebaseService.storageProfileImagesRef.child(fileName)
        let uploadTask = profileImageRef.putData(uploadData, metadata: nil) { (metadata, err) in
            if err != nil
            {
                print(err!)
                SVProgressHUD.showError(withStatus: err!.localizedDescription)
                onCompletion(nil)
            }
        }
        
        profileImageRef.downloadURL { (url, err) in
            if err != nil
            {
                print(err!)
                SVProgressHUD.showError(withStatus: err!.localizedDescription)
                onCompletion(nil)
            }
            
            onCompletion(url)
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            SVProgressHUD.showProgress(snapshot.progress?.fractionCompleted.float ?? 0.5)
        }
    }
    
    fileprivate func registerCurrentUser(with values: [String: Any])
    {
        FirebaseService.databaseUsersRef.updateChildValues(values) { (err, _) in
            if err != nil
            {
                SVProgressHUD.showError(withStatus: err!.localizedDescription)
                print(err!)
            }
        }
    }
    
    @objc fileprivate func handleSignup()
    {
        SVProgressHUD.show(withStatus: "Signing up...")
        authenticateCurrentUser()
    }
}

//MARK:- UIImagePicker Methods

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalPhoto = info[.originalImage] as? UIImage
        {
            pickPhotoButton.setImage(originalPhoto.withRenderingMode(.alwaysOriginal), for: .normal)
            pickPhotoButton.layer.cornerRadius = pickPhotoButton.height / 2
            pickPhotoButton.layer.borderColor = UIColor.appSecondaryColor.cgColor
        }
        else if let editedPhoto = info[.editedImage] as? UIImage
        {
            pickPhotoButton.setImage(editedPhoto.withRenderingMode(.alwaysOriginal), for: .normal)
            pickPhotoButton.layer.cornerRadius = pickPhotoButton.height / 2
            pickPhotoButton.layer.borderColor = UIColor.appSecondaryColor.cgColor
        }
        
        dismiss(animated: true, completion: nil)
    }
}
