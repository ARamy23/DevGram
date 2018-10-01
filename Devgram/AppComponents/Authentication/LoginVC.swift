//
//  LoginVC.swift
//  Devgram
//
//  Created by ScaRiLiX on 9/30/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    let signUpButton: UIButton =
    {
        let btn = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Signup", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appPrimaryColor]))
        attributedText.append(NSAttributedString(string: "!"))
        btn.setAttributedTitle(attributedText, for: .normal)
        btn.addTarget(self, action: #selector(switchToRegistering), for: .touchUpInside)
        return btn
    }()
    
    //MARK:- View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSignUpButton()
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupView()
    {
        view.backgroundColor = .white
    }
    
    fileprivate func setupSignUpButton()
    {
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (maker) in
            maker.left.bottom.right.equalTo(view)
            maker.height.equalTo(50)
        }
    }
    
    //MARK:- Logic
    
    @objc fileprivate func switchToRegistering()
    {
        navigationController?.pushViewController(RegisterVC())
    }
}
