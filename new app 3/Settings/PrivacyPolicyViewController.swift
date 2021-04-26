//
//  PrivacyPolicyViewController.swift
//  new app 3
//
//  Created by William Hinson on 10/20/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import SafariServices

class PrivacyPolicyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://mixedwithmusic.com/privacy-policy/") {
            UIApplication.shared.open(url)
        }

        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller usi`ng segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
