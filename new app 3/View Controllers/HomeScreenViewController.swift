//
//  HomeScreenViewController.swift
//  new app 3
//
//  Created by William Hinson on 11/20/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class HomeScreenViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    
}
