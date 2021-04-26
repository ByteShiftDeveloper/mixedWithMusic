//
//  UpdatedLoginController.swift
//  new app 3
//
//  Created by William Hinson on 3/17/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UpdatedLoginController: UIViewController {
    
    let keyWindow = UIApplication.shared.connectedScenes
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows.first
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavBar()
        view.backgroundColor = .white
    }
    
    func configureNavBar() {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
//        navigationController?.navigationBar.isHidden = true
    }
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "Long_logo_updated")
        return iv
    }()
    

    
    let emailTextField: UITextField = {
       let label = UITextField()
        label.placeholder = "Email"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let emailIcon: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "envelope")
        iv.tintColor = .black
        iv.setDimensions(width: 36, height: 33)
        return iv
    }()
    
    let passwordTextField: UITextField = {
       let label = UITextField()
        label.placeholder = "Password"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let passwordIcon: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "lock")
        iv.tintColor = .black
        iv.setDimensions(width: 33, height: 33)
        return iv
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.blackColor
        button.layer.cornerRadius = 25
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Don't have an account?", " Sign Up")
//        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()

    let divider = UIView()
    let divider2 = UIView()
    
    let errorLabel :  UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()



    
    
    func configureUI(){
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 382, height: 112)
        
        view.addSubview(emailIcon)
        emailIcon.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 24)
        
        view.addSubview(emailTextField)
        emailTextField.anchor(left: emailIcon.rightAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 16)
        emailTextField.centerY(inView: emailIcon)
        
        view.addSubview(divider)
        divider.anchor(top: emailIcon.bottomAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 2, paddingLeft: 24, paddingRight: 24, height: 0.25)
        divider.backgroundColor = .lightGray
        
        view.addSubview(passwordIcon)
        passwordIcon.anchor(top: divider.bottomAnchor, left: view.leftAnchor, paddingTop: 32, paddingLeft: 24)
        
        view.addSubview(passwordTextField)
        passwordTextField.anchor(left: passwordIcon.rightAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 16)
        passwordTextField.centerY(inView: passwordIcon)
        
        view.addSubview(divider2)
        divider2.anchor(top: passwordIcon.bottomAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 2, paddingLeft: 24, paddingRight: 24, height: 0.25)
        divider2.backgroundColor = .lightGray
        
        view.addSubview(logoutButton)
        logoutButton.centerX(inView: view)
        logoutButton.anchor(top: divider2.bottomAnchor, paddingTop: 32, width: 375, height: 50)
        logoutButton.applyGradient(colors: [UIColor.black.cgColor, Colors.space.cgColor])
        logoutButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        view.addSubview(errorLabel)
        errorLabel.anchor(top: logoutButton.bottomAnchor, paddingTop: 8)
        errorLabel.centerX(inView: view)

        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
    }
    
     @objc func loginTapped() {
    // TODO: Validate Text Fields
        
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        AuthService.shared.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Error logging in \(error.localizedDescription)")
                return
            }
            
//            guard let tab = self.keyWindow?.rootViewController as? TabBarController else { return }
            
//            tab.authenticateUser()
            
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
        }
    }
    
    func resetForm () {
        let alert = UIAlertController(title: "Error logging in", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
