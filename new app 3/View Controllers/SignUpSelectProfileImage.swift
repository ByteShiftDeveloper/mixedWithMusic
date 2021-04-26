//
//  SignUpSelectProfileImage.swift
//  new app 3
//
//  Created by William Hinson on 6/6/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

class SignUpSelectProfileImage: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    
    @IBAction func signupTapped(_ sender: Any) {
        
       transitionToNextController()
    }
    
    func transitionToNextController() {
              
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
}
