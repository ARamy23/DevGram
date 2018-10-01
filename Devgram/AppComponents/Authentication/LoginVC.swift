//
//  LoginVC.swift
//  Devgram
//
//  Created by ScaRiLiX on 9/30/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class LoginVC: UIViewController {

    //MARK:- UI Initialization
    
    let logoContainerView: UIView =
    {
        let view = UIView()
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        
        view.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints({ (maker) in
            maker.center.equalTo(view)
            maker.width.equalTo(200)
            maker.height.equalTo(50)
        })
        view.backgroundColor = .appPrimaryColor
        return view
    }()
    
    let emailTextField: UITextField =
    {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.textColor = .appSecondaryColor
        tf.attributedPlaceholder = NSAttributedString(string: "JohnDoe@iDevAR.com", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appThirdColor])
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        tf.layer.borderColor = UIColor.appThirdColor.cgColor
        tf.layer.borderWidth = 4
        tf.layer.cornerRadius = 16
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingDidEnd)
        return tf
    }()
    
    let passwordTextField: UITextField =
    {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.textColor = .appSecondaryColor
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appThirdColor])
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        tf.layer.borderColor = UIColor.appThirdColor.cgColor
        tf.layer.borderWidth = 4
        tf.layer.cornerRadius = 16
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let loginButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .appThirdColor
        button.setTitleColor(.appForthColor, for: .normal)
        button.layer.cornerRadius = 16
        button.alpha = 0.4
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    
    let notYetRegisteredButton: UIButton =
    {
        let btn = UIButton(type: .custom)
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Signup", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appPrimaryColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]))
        attributedText.append(NSAttributedString(string: "!"))
        btn.setAttributedTitle(attributedText, for: .normal)
        btn.addTarget(self, action: #selector(switchToRegistering), for: .touchUpInside)
        return btn
    }()
    
    //MARK:- View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLogoView()
        setupNotYetRegisteredButton()
        setupInputViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupView()
    {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func setupLogoView()
    {
        view.addSubview(logoContainerView)
        
        logoContainerView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(view)
            maker.height.equalTo(150)
        }
    }
    
    fileprivate func setupNotYetRegisteredButton()
    {
        view.addSubview(notYetRegisteredButton)
        notYetRegisteredButton.snp.makeConstraints { (maker) in
            maker.left.bottom.right.equalTo(view)
            maker.height.equalTo(50)
        }
    }
    
    fileprivate func setupInputViews()
    {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton], axis: .vertical, spacing: 10, alignment: .fill, distribution: .fillEqually)
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { (maker) in
            maker.top.equalTo(logoContainerView.snp.bottom).offset(40)
            maker.left.right.equalTo(view).inset(40)
            maker.height.equalTo(150)
        }
    }
    
    //MARK:- Networking
    
    fileprivate func login(with email: String, and password: String)
    {
        Auth.auth().signIn(withEmail: email, password: password) { (_, err) in
            if err != nil
            {
                print(err!)
                SVProgressHUD.showError(withStatus: err!.localizedDescription)
            }
            
            UIApplication.mainTabBarController()?.setupUI()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK:- Logic
    
    @objc fileprivate func handleLogin()
    {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        login(with: email, and: password)
    }
    
    @objc fileprivate func handleTextInputChange()
    {
        
        UIView.animate(withDuration: 0.5)
        {
            if self.isEmailInputValid(), self.isPasswordValid()
            {
                self.loginButton.backgroundColor = .appPrimaryColor
                self.loginButton.isEnabled = true
                self.loginButton.alpha = 1
            }
            else
            {
                self.loginButton.backgroundColor = .appThirdColor
                self.loginButton.isEnabled = false
                self.loginButton.alpha = 0.4
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
    
    @objc fileprivate func switchToRegistering()
    {
        navigationController?.pushViewController(RegisterVC())
    }
}
