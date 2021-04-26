//
//  WhatAreYouUploadingViewController.swift
//  new app 3
//
//  Created by William Hinson on 2/25/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class WhatAreYouUploadingViewController: UIViewController {
    
    
    @IBOutlet weak var wayuLabel: UILabel!
    @IBOutlet weak var singLabel: UILabel!
    @IBOutlet weak var singleDescriptionLabel: UILabel!
    @IBOutlet weak var uploadSingleButton: UIButton!
    @IBOutlet weak var EPorAlbumLabel: UILabel!
    @IBOutlet weak var epDescriptionLabel: UILabel!
    @IBOutlet weak var uploadEPButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        wayuLabel.text = "What are you uploading?"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let tabBar = self.tabBarController?.tabBar else { return }

        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor.black
        tabBar.isTranslucent = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let tabBar = self.tabBarController?.tabBar else { return }

        tabBar.tintColor = UIColor.black
        tabBar.barTintColor = UIColor.white
        tabBar.isTranslucent = false
        
    }

    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
