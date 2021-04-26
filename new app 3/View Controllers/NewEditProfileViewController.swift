//
//  NewEditProfileViewController.swift
//  new app 3
//
//  Created by William Hinson on 11/13/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

protocol NewEditVCDelegate {
    func didChangePhoto(withString url:String)
}

class NewEditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var usernameDisplay: UITextField!
    @IBOutlet weak var artistBandDJ: UILabel!
    @IBOutlet weak var editArtistBandDJ: UIButton!
    
    var delegate:NewEditVCDelegate?
    


    
    @IBOutlet weak var userBio: UITextView!
    
    let you = ["Artist", "Band", "DJ", "Musician", "Producer"]
    
    var picker:UIPickerView!
    var ref = DatabaseReference.init()
    
    var imagePicker = UIImagePickerController()
    var imagePicked = 0
    
 
       
    
    var databaseRef = Database.database().reference()
    
    
    
    var selectedImage1: UIImage?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        

        getFireBasedata()
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        getFireBasedata()
    }
  
    func getFireBasedata(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.databaseRef.child("users/profile").child(uid).observeSingleEvent(of:.value) { (snapshot:DataSnapshot) in
            let dict = snapshot.value as? [String:Any]
            self.usernameDisplay.text = dict!["username"] as? String
            self.artistBandDJ.text = dict!["What do you consider yourself?"] as? String
            self.userBio.text = dict!["bio"] as? String
            
            if(dict!["photoURL"] != nil) {

            let databaseProfilePic = dict!["photoURL"] as! String

                if let data = NSData(contentsOf: NSURL(string: databaseProfilePic)! as URL) {

                    self.setProfilePic(imageView: self.imageView1,imageToSet:UIImage(data: data as Data)!)
                }
            }
            
            if(dict!["headerURL"] != nil) {
                let databaseHeaderPic = dict!["headerURL"] as! String

                if let data2 = NSData(contentsOf: NSURL(string:databaseHeaderPic)! as URL) {

                    self.setHeaderPic(imageView2: self.imageView2, imageToSet2: UIImage(data: data2 as Data)!)
                    }
                }
            }
        
    }

    @IBAction func chooseImage1(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            imagePicked = (sender as AnyObject).tag
            present(imagePicker, animated: true)
        }

        }
    
    @IBAction func chooseImage2(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            imagePicked = (sender as AnyObject).tag
                present(imagePicker, animated: true)
    }

    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//        let pickedImage2 = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if imagePicked == 1 {
            self.imageView1.image = pickedImage
        }
        else if imagePicked == 2 {
            self.imageView2.image = pickedImage
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
@IBAction func saveButton(_ sender: Any) {
    self.saveFIRData()
    self.saveHeaderPhoto()
    self.savePicker()
    self.saveUpdateName()
    self.saveBio()
    
    dismiss(animated: true, completion: nil)

    
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        }
    
    
    func saveFIRData() {
        guard imageView1.image != nil else { return }
//        print("profile image= \(image)")


        self.uploadProfileImage{ url in

            
            if url != nil {
                self.saveProfileImage(profileURL: url!){ success in
                        if success != nil{
                            self.changePhotoInPosts(photoURL: success!.absoluteString)
                            print("yes")
                           
                    }
                }

                self.dismiss(animated: true, completion: nil)
                

            }
            
            else{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    func saveHeaderPhoto() {
        guard imageView2.image != nil else { return }
//        print("header image2= \(image2)")
        
        self.uploadHeaderImage{ url in
            
            if url != nil {
                self.saveHeaderImage(profileURL2: url!){ success in
                   if success != nil {
                        print("yes")
                    }
                }
            
            }
        }
    }
    
    
    func saveBio() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let updateBio = userBio.text
            
            let ref = Database.database().reference().root
            
            let userObject = [
                "bio":updateBio
            ]
            
            ref.child("users/profile").child(uid).updateChildValues(userObject as [AnyHashable : Any])
            
        
    }
    
    
     
    
    
    @IBAction func editButton(_ sender: Any) {
        self.editButtonTapped()
    }
    
    func editButtonTapped() {
    let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 150, height: 150)
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        picker.delegate = self
        picker.dataSource = self
        vc.view.addSubview(picker)
        let editBandDJAlert = UIAlertController(title: "What do you consider yourself?", message: nil, preferredStyle: UIAlertController.Style.alert)
        editBandDJAlert.setValue(vc, forKey: "contentViewController")
        editBandDJAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        editBandDJAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editBandDJAlert, animated:true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return you.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return you[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        artistBandDJ.text = you[row]
    }
    internal func setProfilePic(imageView:UIImageView,imageToSet:UIImage) {
           imageView1.layer.cornerRadius = imageView1.bounds.height / 2
           imageView1.layer.masksToBounds = true
           imageView1.image = imageToSet
       }
       
    internal func setHeaderPic(imageView2:UIImageView,imageToSet2:UIImage) {
           imageView2.layer.masksToBounds = true
           imageView2.image = imageToSet2
       }
//
    func savePicker() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let selectedValue = artistBandDJ.text
        
        let ref = Database.database().reference().root
        
        let userObject = [
            "What do you consider yourself?":selectedValue
        ]
        ref.child("users/profile").child(uid).updateChildValues(userObject as [AnyHashable : Any])
    }
    
    func saveUpdateName() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let updatedName = usernameDisplay.text
        
        let ref = Database.database().reference().root
        
        let userObject = [
            "username":updatedName
        ]
        
        ref.child("users/profile").child(uid).updateChildValues(userObject as [AnyHashable : Any])
        changeNameInPost(name: updatedName!)
    }
    
   
    
}

extension NewEditProfileViewController {
    
    func getCurrentUserPost(){
         let userKey:String? = Auth.auth().currentUser?.uid
         let ref = Database.database().reference().child("posts").queryOrdered(byChild: "author/uid").queryEqual(toValue: userKey)
         ref.observe(.value){ snapshot in
             
             print(snapshot)
         }
     }
    
    
    func uploadProfileImage( completion: @escaping (_ url: URL?)->()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("users/\(uid)")
        let storageRef = Storage.storage().reference().child("profileImage").child("\(uid)")

        let imageData = imageView1.image?.jpegData(compressionQuality: 0.8)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        storageRef.putData(imageData!, metadata: metaData) { (metaData, error) in
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

    func uploadHeaderImage( completion: @escaping (_ url: URL?)->()) {
          guard let uid = Auth.auth().currentUser?.uid else { return }
//          let storageRef = Storage.storage().reference().child("users/\(uid)")
         let storageRef = Storage.storage().reference().child("headerImage").child("\(uid)")
          let imageData2 = imageView2.image?.jpegData(compressionQuality: 0.8)
          let metaData = StorageMetadata()
          metaData.contentType = "image/jpeg"
          storageRef.putData(imageData2!, metadata: metaData) { (metaData, error) in
              if error == nil{
                  print("success for header")
                  storageRef.downloadURL(completion: { (url, error) in
                      completion(url)
                  })
              }else{
                
                  print("error in save image")
                  completion(nil)
              }
          }
      }
    
    
    func saveProfileImage(profileURL:URL, completion: @escaping ((_ url: URL?) -> ())){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userObject = [
            "photoURL": profileURL.absoluteString
        ] as [String:Any]
        
        self.ref.child("users/profile").child(uid).updateChildValues(userObject)
        completion(profileURL)
        }

    func saveHeaderImage(profileURL2:URL, completion: @escaping ((_ url: URL?) -> ())){
    guard let uid = Auth.auth().currentUser?.uid else { return }
    let userObject = [
        "headerURL": profileURL2.absoluteString
    ] as [String:Any]
    self.ref.child("users/profile").child(uid).updateChildValues(userObject)
        completion(profileURL2)

    }
    
    func changePhotoInPosts(photoURL: String){
            let userKey:String? = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("posts").queryOrdered(byChild: "author/uid").queryEqual(toValue: userKey)
        var didChangedPic : Bool = true
         ref.observe(.value){ snapshot in
     //        print(snapshot.value)
             guard let childValue = snapshot.value as? [String:Any] else{return}
             let childKeys = Array(childValue.keys)

             for i in 0...childKeys.count - 1{
                 let photoRef = Database.database().reference().child("posts").child(childKeys[i]).child("author").child("photoURL")
              
                 photoRef.setValue(photoURL)
             }
            if didChangedPic{
                NotificationCenter.default.post(name: Notification.Name("UserInfoChanged"), object: nil)
                didChangedPic = false
            }
              
            }
        }
    
     func changeNameInPost(name: String){
                let userKey:String? = Auth.auth().currentUser?.uid
                let ref = Database.database().reference().child("posts").queryOrdered(byChild: "author/uid").queryEqual(toValue: userKey)
        ref.observeSingleEvent(of: .value){ snapshot in
         //        print(snapshot.value)
                 guard let childValue = snapshot.value as? [String:Any] else{return}
                 let childKeys = Array(childValue.keys)
                 print("name \(childKeys[0])")

                 for i in 0...childKeys.count - 1{
                     let nameRef = Database.database().reference().child("posts").child(childKeys[i]).child("author").child("username")
                  
                     nameRef.setValue(name)
                 }
                 
                }
            }
}
