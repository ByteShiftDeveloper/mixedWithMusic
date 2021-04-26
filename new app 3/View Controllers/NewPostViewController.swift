//
//  NewPostViewController.swift
//  new app 3
//
//  Created by William Hinson on 11/8/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol NewPostVCDelegate {
    func didUploadPost(withID id:String)
}

class NewPostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var databaseRef = Database.database().reference()
    

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet var toolbarView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    var delegate:NewPostVCDelegate?
    
    var imagePicker = UIImagePickerController()
    var imagesArray = [AnyObject]()
        
    @IBAction func handlePostButton() {
        print(textView.text)
        if  postImage.image != nil && textView.text != "" {
             uploadPostPhoto{ photoURL in
                self.postWithImageAndText(url: photoURL!)
           }
        } else if (textView.text != "") {
            postNewPost()
        } else if (postImage.image != nil) {
            uploadPostPhoto{ photoURL in
            self.postImagesOnly(url: photoURL!)
            }
        }
//        self.textView.attributedText.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, self.textView.text.count), options: []) { (value, range, true) in
//
//            if(value is NSTextAttachment) {
//                let attacthment = value as! NSTextAttachment
//                var image : UIImage? = nil
//
//                if(attacthment.image !== nil) {
//                    image = attacthment.image!
//                    imagesArray.append(image!)
//                } else {
//                    print("No image found")
//                }
//            }
//        }
//
//
//        let postLength = textView.text == "Say what\'s on your mind/n￼" ?  0 : textView.text.count
//        let numImages = imagesArray.count
//
//        if(postLength>0 && numImages>0) {
//             uploadPostPhoto{ photoURL in
//                self.postWithImageAndText(url: photoURL!)
//            }
//
//        } else if (postLength>0) {
//
//            postNewPost()
//
//        } else if (numImages>0) {
//            uploadPostPhoto{ photoURL in
//                self.postImagesOnly(url: photoURL!)
//
//            }
//        }
        
    }
    func postNewPost() {
        
         let postRef = Database.database().reference().child("posts").childByAutoId()
        
        guard let userProfile = UserService.currentUserProfile else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        let postObject = [
                "uid": userProfile.uid,
                "username": userProfile.fullname,
                "photoURL": userProfile.photoURL.absoluteString,
            "likes": 0,
            "text": textView.text!,
            "timestampt":  Int(NSDate().timeIntervalSince1970)] as [String:Any]
        
        postRef.setValue(postObject, withCompletionBlock: {error, ref in
            if error == nil {
                guard let postID = postRef.key else { return }
                
                Database.database().reference().child("user-posts").child(uid).updateChildValues([postID: 1]) { (err, ref) in
                    
                    self.uploadHashtagToServer(withPostiD: postID)

                }
                
                self.delegate?.didUploadPost(withID: ref.key!)
//            self.dismiss(animated: true, completion: nil)
            } else {
                //Handle the error
            }
        })
    }
    
    
    func postWithImageAndText(url:URL) {

       guard let userProfile = UserService.currentUserProfile else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let postRef = Database.database().reference().child("posts").childByAutoId()
        let postObject = [     "uid": userProfile.uid,
                               "username": userProfile.fullname,
                               "photoURL": userProfile.photoURL.absoluteString,
                                "likes": 0,
                                "text": textView.text!,
                                "picture": url.absoluteString,
                                "timestampt":  Int(NSDate().timeIntervalSince1970)] as [String:Any]
                                                      
        postRef.setValue(postObject, withCompletionBlock: {error, ref in
            if error == nil {
                guard let postID = postRef.key else { return }
                             
                             Database.database().reference().child("user-posts").child(uid).updateChildValues([postID: 1]) { (err, ref) in
                                
                                self.uploadHashtagToServer(withPostiD: postID)
                             }
                self.delegate?.didUploadPost(withID: ref.key!)
//                self.dismiss(animated: true, completion: nil)
            }
            else {
                       }
                   })
    }
    
     func uploadPostPhoto( completion: @escaping (_ url: URL?)->()) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let userProfile = UserService.currentUserProfile else { return }
            let storageRef = Storage.storage().reference().child("users/profile/\(uid)/\(UUID())")
        let lowResImageData = (postImage.image as! UIImage).jpegData(compressionQuality: 0.50)
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"

            storageRef.putData(lowResImageData!, metadata: metaData) { (metaData, error) in
                if error == nil{
                    
                    print("success for profile photo")
                    storageRef.downloadURL(completion: { (url, error) in
                         completion(url)
                    })
                }else{
                    print("error in save image")
                    completion(nil)
                }
            }
        }
    
    func postImagesOnly(url:URL) {
        //var imagesArray = [AnyObject]()
        guard let userProfile = UserService.currentUserProfile else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postRef = Database.database().reference().child("posts").childByAutoId()
        let postObject = [
                        "uid": userProfile.uid,
                        "username": userProfile.fullname,
                        "photoURL": userProfile.photoURL.absoluteString,
                        "likes": 0,
                        "text": "",
                        "picture": url.absoluteString,
                        "timestampt":  Int(NSDate().timeIntervalSince1970)] as [String:Any]
                                               
        postRef.setValue(postObject, withCompletionBlock: {error, ref in
            if error == nil {
                guard let postID = postRef.key else { return }
                
                Database.database().reference().child("user-posts").child(uid).updateChildValues([postID: 1]) { (err, ref) in
                }
                self.delegate?.didUploadPost(withID: ref.key!)
//                self.dismiss(animated: true, completion: nil)
            }
            else {
                }
            })
                        
        }
//
//                let uploadTask = pictureStorageRef.putData(lowResImageData!,metadata: nil){metadata,error in
//
//                               if (error == nil) {
//                               storageRef.downloadURL { (url, error) in
//
//                                   guard let userProfile = UserService.currentUserProfile else { return }
//
//                                let postObject = [
//                                    "author": [
//                                        "uid": userProfile.uid,
//                                        "username": userProfile.fullname,
//                                        "photoURL": userProfile.photoURL.absoluteString
//                                    ],
//                                    "picture": url!.absoluteString,
//                                    "timestamp": ["sv.":"timestamp"]
//                                ] as [String:Any]
//
//                                postRef.setValue(postObject, withCompletionBlock: {error, ref in
//                                    if error == nil {
//                                        self.delegate?.didUploadPost(withID: ref.key!)
//                                    self.dismiss(animated: true, completion: nil)
//                                    } else {
//                                        //Handle the error
//                                    }
//                                })
//                        }
//                    }
//                }
//
//    }
    @IBAction func handleCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    textView.resignFirstResponder()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
        super.dismiss(animated: flag, completion: completion)
        })
    
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onclickImage))
//        postImage.addGestureRecognizer(panGesture)
        
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(NewPostViewController.imageTapped))
        postImage.addGestureRecognizer(pictureTap)
        postImage.isUserInteractionEnabled = true
        
        textView.inputAccessoryView = toolbarView
        
        profilePic.layer.cornerRadius = profilePic.bounds.height / 2
        
        textView.delegate = self
        
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
//        self.databaseRef.child("users").child(uid).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
//            let dict = snapshot.value as? [String:Any]
//            if(dict!["photoURL"] != nil) {
//
//            let databaseProfilePic = dict!["photoURL"] as! String
//
//                if let data = NSData(contentsOf: NSURL(string: databaseProfilePic)! as URL) {
//
//                    self.setProfilePic(imageView: self.profilePic,imageToSet:UIImage(data: data as Data)!)
//
//                }
//            }
//       }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
        
        //Remove the nav shadow underline
        navigationController?.navigationBar.shadowImage = UIImage ()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
    
    
    @IBAction func uploadAudioButton(_ sender: Any) {
        print("Selected audio upload")
        let controller = WhatAreYouUploadingViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    
    @IBAction func selectImageFromPhotos(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
//            print("text\(textView.text)")
            if textView.text != nil{
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
//        var attributedString = NSMutableAttributedString()
//                if self.textView.text.count>0 {
//                    attributedString = NSMutableAttributedString(string: self.textView.text)
//                } else {
//                    attributedString = NSMutableAttributedString(string: "Say what's on your mind\n")
//                }
//
//                let textAttatchment = NSTextAttachment()
//
//                textAttatchment.image = image
//
//                let oldWidth:CGFloat = textAttatchment.image!.size.width
//
//                let scaleFactor:CGFloat = oldWidth/(textView.frame.size.width-50)
//
//                textAttatchment.image = UIImage(cgImage: textAttatchment.image!.cgImage!, scale: scaleFactor, orientation: .up)
//
//                let attrStringWithImage = NSAttributedString(attachment: textAttatchment)
//
//                attributedString.append(_:attrStringWithImage)
//
//                textView.attributedText = attributedString
                self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
           postImage.image = editedImage
       } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
       postImage.image = originalImage
       }
       
       dismiss(animated: true, completion: nil)
        
        
//        var atrributedString = NSMutableAttributedString()
//
//                if let image = info[.editedImage] as? UIImage {
//        //                imageView.image = image
//
//                            if(self.textView.text.count>0) {
//                                atrributedString = NSMutableAttributedString(string:self.textView.text,attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)])
//
//                            } else {
//                                atrributedString =
//                            NSMutableAttributedString(string: "Say what's on your mind/n",attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 20)])
//                            }
//
//                            let textAttatchment = NSTextAttachment()
//                            textAttatchment.image = image
//
//                            let oldWidth:CGFloat = textAttatchment.image!.size.width
//
//                            let scaleFactor:CGFloat = oldWidth/(textView.frame.size.width - 50)
//
//                    textAttatchment.image = UIImage(cgImage: textAttatchment.image!.cgImage!, scale: scaleFactor, orientation: .up)
//
//                            let attrStringWithImage = NSAttributedString(attachment: textAttatchment)
//
//                            atrributedString.append(attrStringWithImage)
//
//                            textView.attributedText = atrributedString
//                            self.dismiss(animated: true, completion: nil)
//                    //        imageView.image = image
//                            print("Image shown")
//                    }
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UIPanGestureRecognizer(target: self, action: #selector(onclickImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.toolbarView.isHidden = true
    
    }

    @objc func dismissFullscreenImage(_ sender: UIPanGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.toolbarView.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    @objc func onclickImage(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        
        sender.setTranslation(CGPoint.zero, in: self.view)
        sender.view?.removeFromSuperview()

    }
    
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//
//        var atrributedString = NSMutableAttributedString()
//
//        if(self.textView.text.count>0) {
//            atrributedString = NSMutableAttributedString(string:self.textView.text)
//        } else {
//            atrributedString = NSMutableAttributedString(string: "Say what's on your mind/n")
//        }
//
//        let textAttatchment = NSTextAttachment()
//
//        textAttatchment.image = image
//
//        let oldWidth:CGFloat = textAttatchment.image!.size.width
//
//        let scaleFactor:CGFloat = oldWidth/(textView.frame.size.width - 50)
//
//        textAttatchment.image = UIImage(cgImage: textAttatchment.image!.cgImage!, scale: scaleFactor, orientation: .up)
//
//        let attrStringWithImage = NSAttributedString(attachment: textAttatchment)
//
//        atrributedString.append(attrStringWithImage)
//
//        textView.attributedText = atrributedString
//        self.dismiss(animated: true, completion: nil)
////        imageView.image = image
//        print("Image shown")
//    }
//

    @IBAction func didTapTakePhotoButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    

//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//
//        var attributedString = NSMutableAttributedString()
    //        if self.textView.text.count>0 {
    //            attributedString = NSMutableAttributedString(string: self.textView.text)
    //        } else {
    //            attributedString = NSMutableAttributedString(string: "Say what's on your mind\n")
    //        }
    //
    //        let textAttatchment = NSTextAttachment()
    //
    //        textAttatchment.image = image
    //
    //        let oldWidth:CGFloat = textAttatchment.image!.size.width
    //
    //        let scaleFactor:CGFloat = oldWidth/(textView.frame.size.width-50)
    //
    //        textAttatchment.image = UIImage(cgImage: textAttatchment.image!.cgImage!, scale: scaleFactor, orientation: .up)
    //
    //        let attrStringWithImage = NSAttributedString(attachment: textAttatchment)
    //
    //        attributedString.append(_:attrStringWithImage)
    //
    //        textView.attributedText = attributedString
    //        self.dismiss(animated: true, completion: nil)
//
//
//    }
    
    
    func uploadHashtagToServer(withPostiD postID: String) {
        
        guard let text = textView.text else { return }
        
        let words: [String] = text.components(separatedBy: .whitespacesAndNewlines)
        
        for var word in words {
            
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: .punctuationCharacters)
                word = word.trimmingCharacters(in: .symbols)
                
                let hashtagValues = [postID: 1]
                
                HASHTAGPOSTREF.child(word.lowercased()).updateChildValues(hashtagValues)
            }
        }
    }
    
    internal func setProfilePic(imageView:UIImageView,imageToSet:UIImage) {
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
        }

    }


