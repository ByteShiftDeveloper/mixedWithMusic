//
//  EditProfileViewController.swift
//  new app 3
//
//  Created by William Hinson on 11/13/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EditProfileViewController: UIViewController {

    var imagePicker:UIImagePickerController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        
        
    }
    @objc func openImagePicker(_ sender:Any) {
        //Open Image Picker
    }

}
