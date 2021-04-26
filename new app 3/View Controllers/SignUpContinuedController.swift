//
//  SignUpContinuedController.swift
//  new app 3
//
//  Created by William Hinson on 6/6/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

class SignUpContinuedController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        transitionToNextController()
    }
    
    func transitionToNextController() {
          
//           let homeViewController = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
//           view.window?.rootViewController = homeViewController
//           view.window?.makeKeyAndVisible()
        
        let controller = SignUpSelectProfileImage()
        navigationController?.pushViewController(controller, animated: true)
        
       }
    
    
}
