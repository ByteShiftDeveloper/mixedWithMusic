//
//  ViewController.swift
//  new app 3
//
//  Created by William Hinson on 11/5/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import AuthenticationServices

class ViewController: UIViewController {

    
    @IBOutlet weak var signupButton: UIButton?
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var faceBookButton: UIView?
    
    @IBOutlet weak var appleButton: UIView?

    
    @IBOutlet weak var existingAccountLabel: UILabel!
    
    
    var gradientLayer: CAGradientLayer!
    
    let mwmImage = UIImageView(image: UIImage(named: "new mwm app logo"))
    let splashView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

        Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let currentUser = user {
                print("user is signed in")
                
                let mainstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let HomeViewController: UIViewController = mainstoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
                
                self.present(HomeViewController, animated:  false, completion: nil)
            }
        })
        
        func authUser() {
             Auth.auth().signIn(withEmail: "users email", password: "password", completion: { (auth, error) in
                if let x = error { //example error checking
                    let err = x as NSError
                    switch err.code {
                    case AuthErrorCode.wrongPassword.rawValue:
                        print("wrong password")
                    case AuthErrorCode.invalidEmail.rawValue:
                        print("invalued email")
                    default:
                        print("unknown error")
                    }
                } else { //no error, user is authed
                    if let user = auth?.user {
                        print("uid: \(user.uid)") //print their uid
                    }
                }
            })
        }

        splashView.backgroundColor = .black
        view.addSubview(splashView)
        splashView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        mwmImage.contentMode = .scaleAspectFit
        splashView.addSubview(mwmImage)
        mwmImage.frame = CGRect(x: splashView.frame.midX - 50, y: splashView.frame.midY - 50, width: 100, height: 100)
        
        
        setUpElements()
    }

    func setUpElements() {
    
    }
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "Long_logo_updated")
        return iv
    }()
    
    let registerContainer: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let fbContainer: UIButton = {
       let button = UIButton()
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 0.5
        button.setTitle("Continue with Facebook", for: .normal)
        button.applyGradient(colors: [UIColor.black.cgColor, Colors.space.cgColor])
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()

    let appleContainer: UIButton = {
       let button = UIButton()
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 0.5
        button.setTitle("Continue with Apple", for: .normal)
        button.applyGradient(colors: [UIColor.black.cgColor, Colors.space.cgColor])
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    let fbIcon: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "facebook-64")
        iv.tintColor = .white
        iv.setDimensions(width: 25, height: 25)
        return iv
    }()
    
    let appleIcon: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "apple-64")
        iv.tintColor = .white
        iv.setDimensions(width: 25, height: 25)
        return iv
    }()

    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
  
        
        view.backgroundColor = .white
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.scaleDownAnimation()
        }
    }
    
    func configureUI(){
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 96)
        logoImageView.setDimensions(width: 382, height: 112)
        
//        view.addSubview(registerContainer)
//        registerContainer.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 64, paddingLeft: 16, paddingRight: 16, width: view.frame.width / 2, height: 50)
//        registerContainer.centerX(inView: view)
        signupButton?.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 300, paddingLeft: 16, paddingRight: 16, width: view.frame.width / 2, height: 50 )
        signupButton?.layer.cornerRadius = 25
        signupButton?.applyGradient(colors: [UIColor.black.cgColor, Colors.space.cgColor])
        
        
        view.addSubview(fbContainer)
        fbContainer.anchor(top: signupButton?.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingRight: 16, width: view.frame.width / 2, height: 50)
        fbContainer.centerX(inView: view)
        fbContainer.applyGradient(colors: [Colors.fbBlue.cgColor, Colors.fbLightBlue.cgColor])
        
        view.addSubview(appleContainer)
        appleContainer.anchor(top: fbContainer.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingRight: 16, width: view.frame.width / 2, height: 50)
        appleContainer.centerX(inView: view)
        appleContainer.applyGradient(colors: [Colors.apBlue.cgColor, Colors.apPurple.cgColor, Colors.apRed.cgColor])
        
        
        fbContainer.addSubview(fbIcon)
        fbIcon.anchor(left: fbContainer.leftAnchor, paddingLeft: 32)
        fbIcon.centerY(inView: fbContainer)
        
        appleContainer.addSubview(appleIcon)
        appleIcon.anchor(left: appleContainer.leftAnchor, paddingLeft: 32)
        appleIcon.centerY(inView: appleContainer)
      
    }
    
    
    func scaleDownAnimation() {
           UIView.animate(withDuration: 0.5, animations: {
               self.mwmImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
               
           }) { ( success ) in
               self.scaleUpAnimation()
               
           }
           
       }
       
       func scaleUpAnimation() {
           
           UIView.animate(withDuration: 0.35, delay: 0.1, options: .curveEaseIn, animations: {
               self.mwmImage.transform = CGAffineTransform(scaleX: 5, y: 5)
               
           }) { ( success ) in
               self.removeSplashScreen()
           }
       }
       
       func removeSplashScreen() {
           splashView.removeFromSuperview()
       }
    

    
    let gesture = UITapGestureRecognizer(target: self, action: #selector(handleFaceBookSignIn))
    
    
    @objc func handleFaceBookSignIn(sender: UITapGestureRecognizer) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(granted: _, declined: _, token: _):
                self.signIntoFireBase()
            case .failed(let err):
                print(err)
            case .cancelled:
                print("cancelled")
            }
        }
    }
    
    fileprivate func signIntoFireBase() {
        guard let accessToken = AccessToken.current?.tokenString else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credential) { (user, err) in
            if let err = err {
                print(err)
            }
            print("Successfully logged into facebook")
        }
    }
    
    
    @objc func handleAppleSignIn() {
        completeAppleSignIn()
    }
    
    func completeAppleSignIn() {
        let request = createAppleIDReaquest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
    }
    
    func createAppleIDReaquest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        
        return request
        
    }
}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback recieved, but no login request was sent")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { (authDataResult, error) in
                if let user = authDataResult?.user {
                    print("\(user.uid) & \(user.email)")
                    
                    let ref = Database.database().reference().root
                    
               
                    
                    let userObject = [
                        "email": user.email,
                        "fullname":user.displayName,
        //                        "fcmToken": fcmToken,
        //                        "username":username,
                        "photoURL": "https://firebasestorage.googleapis.com/v0/b/mixed-with-music-28704.appspot.com/o/profile_images%2Fblank-user-profile.svg?alt=media&token=62beb9d3-99ae-436a-9def-d35c9b1bb2b2"
                    ] as [String:Any]
                    ref.child("users").child(user.uid).updateChildValues(userObject)
                    
                    let controller = CreateUserNameViewController()
    
                    self.navigationController?.pushViewController(controller, animated: true)
                
                }
            }
        }
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: Array<Character> =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}

import CryptoKit

// Unhashed nonce.
fileprivate var currentNonce: String?

//@available(iOS 13, *)
//func startSignInWithAppleFlow() {
//  let nonce = randomNonceString()
//  currentNonce = nonce
//  let appleIDProvider = ASAuthorizationAppleIDProvider()
//  let request = appleIDProvider.createRequest()
//  request.requestedScopes = [.fullName, .email]
//  request.nonce = sha256(nonce)
//
//  let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//  authorizationController.delegate = self
//  authorizationController.presentationContextProvider = self
//  authorizationController.performRequests()
//}

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    return String(format: "%02x", $0)
  }.joined()

  return hashString
}



