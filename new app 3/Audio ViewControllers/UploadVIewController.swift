//
//  UploadVIewController.swift
//  audioPlayerApp
//
//  Created by William Hinson on 1/28/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit

class UploadViewController: UIViewController {

    @IBOutlet weak var trackImage: UIImageView!
    
    @IBOutlet weak var addTrackImage: UIButton!
    @IBOutlet weak var trackTitle: UITextField!
    @IBOutlet weak var addGenre: UIButton!
    
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
  
    
    @IBAction func didTapAddPhoto(_ sender: Any) {
       
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                    self.imagePicker.sourceType = .savedPhotosAlbum
                    self.imagePicker.allowsEditing = true
                    self.present(self.imagePicker, animated: true, completion: nil)
            }
    }
    
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
     if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
        trackImage.image = editedImage
    }
    
    dismiss(animated: true, completion: nil)
    
 }
}

