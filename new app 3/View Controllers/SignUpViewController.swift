//
//  SignUpViewController.swift
//  new app 3
//
//  Created by William Hinson on 11/5/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseMessaging

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
        
    @IBOutlet weak var signupButton: UIButton!
    

    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
//        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.allowsEditing = true
//        
//        profileImage.layer.cornerRadius = 75
//        profileImage.layer.borderWidth = 2
//        profileImage.layer.borderColor = UIColor.white.cgColor
//        profileImage.layer.masksToBounds = true
//        
//        signupButton.setGradientBackground(colorOne: .darkGray, colorTwo: .black)
//        signupButton.layer.cornerRadius = signupButton.frame.size.height/2
//        signupButton.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        // Hide the error lable
        errorLabel.alpha = 0
        
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 150, height: 150)
        iv.layer.cornerRadius = 150 / 2
        iv.backgroundColor = .lightGray
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
//        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
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
        label.isSecureTextEntry = true
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
    
    let fullNameTextField: UITextField = {
       let label = UITextField()
        label.placeholder = "Fullname"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let fullnameIcon: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "person")
        iv.tintColor = .black
        iv.setDimensions(width: 36, height: 33)
        return iv
    }()
    
    let usernameTextField: UITextField = {
       let label = UITextField()
        label.placeholder = "Username"
        label.textColor = .black
        label.isSecureTextEntry = true
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let usernameIcon: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "person")
        iv.tintColor = .black
        iv.setDimensions(width: 33, height: 33)
        return iv
    }()
    
    let divider = UIView()
    let divider2 = UIView()
    let divider3 = UIView()
    let divider4 = UIView()
    
    
    
    func configureUI() {
        
        view.addSubview(profileImageView)
        profileImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 24)
    
        
        view.addSubview(emailIcon)
        emailIcon.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 24)
        
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

        view.addSubview(fullnameIcon)
        fullnameIcon.anchor(top: divider2.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 24)

        view.addSubview(fullNameTextField)
        fullNameTextField.anchor(left: fullnameIcon.rightAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 16)
        fullNameTextField.centerY(inView: fullnameIcon)

        view.addSubview(divider3)
        divider3.anchor(top: fullnameIcon.bottomAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 2, paddingLeft: 24, paddingRight: 24, height: 0.25)
        divider3.backgroundColor = .lightGray

        view.addSubview(usernameIcon)
        usernameIcon.anchor(top: divider3.bottomAnchor, left: view.leftAnchor, paddingTop: 32, paddingLeft: 24)

        view.addSubview(usernameTextField)
        usernameTextField.anchor(left: usernameIcon.rightAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 16)
        usernameTextField.centerY(inView: usernameIcon)

        view.addSubview(divider4)
        divider4.anchor(top: usernameIcon.bottomAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 2, paddingLeft: 24, paddingRight: 24, height: 0.25)
        divider4.backgroundColor = .lightGray

        signupButton?.anchor(top: divider4.bottomAnchor, paddingTop: 24)
        signupButton?.centerX(inView: view)
    }
  
    // check the fields and validate that data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message.
    func validateFields() -> String? {
        
        // Check if fields are filled in
        if fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
        
            return "Please fill out all fields"
        }
        
        //Check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // password isn't secure enough
            return "Please make sure that password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
     if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
        profileImageView.image = editedImage
    
    dismiss(animated: true, completion: nil)
        }
    }


    @IBAction func signupTapped(_ sender: Any) {
 
    // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            //There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
           
            // Create cleaned versions of the data
            let fullname = fullNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            let controller = tellusmoreRegistrationPage()
            self.navigationController?.pushViewController(controller, animated: true)
           

            
            // Create the user
//            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
//
//            //Check for errors
//                if err != nil {
//
//                    //there was an error creating the user
//                    self.showError("error creating users")
//                }
//                else {
//
//                    guard let fcmToken = Messaging.messaging().fcmToken else { return }
//                    guard let imageData = self.profileImageView.image?.jpegData(compressionQuality: 0.3) else { return }
//                    let filename = NSUUID().uuidString
//                    let storageRef = Storage.storage().reference().child("profileImage").child(filename)
//                    storageRef.putData(imageData, metadata: nil) { (meta, error) in
//                        storageRef.downloadURL { (url, error) in
//                            guard let profileImageURL = url?.absoluteString else { return }
//
//                            // User was created successfully, now store first name and last name
//                            let ref = Database.database().reference().root
//
//
//                            let userObject = [
//                                "email": email,
//                                "fullname":fullname,
//                                "fcmToken": fcmToken,
//                                "username":username,
//                                "photoURL":profileImageURL
//                            ] as [String:Any]
//                            ref.child("users").child((result!.user.uid)).updateChildValues(userObject)
//
//                            ref.child("user-usernames").updateChildValues([username: result!.user.uid])
//
//                                // Transition to home screen
////                                self.transitionToHome()
//
//                            let controller = tellusmoreRegistrationPage()
//                            self.navigationController?.pushViewController(controller, animated: true)
//                        }
//                    }
//                }
//            }
           
        }
    }
    
    func showError(_ message:String) {
    
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
       
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()

    }
    
    func transitionToNext() {
        let controller = SignUpContinuedController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func dismiss(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
  
}
