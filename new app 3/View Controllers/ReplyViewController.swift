//
//  ReplyViewController.swift
//  new app 3
//
//  Created by William Hinson on 2/28/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

class ReplyViewController: UIViewController, UITextViewDelegate {
    
    
    var databaseRef = Database.database().reference()

    @IBOutlet weak var userPic: UIImageView!
    
    
    @IBOutlet weak var replyingtoUsernameLabel: UILabel!
    @IBOutlet weak var replyingLabel: UILabel!
    @IBOutlet weak var replyPlaceHolder: UILabel!
    @IBOutlet weak var replyText: UITextView!
    @IBOutlet weak var ReplyImage: UIImageView!
    @IBOutlet weak var replyButton: UIBarButtonItem!
    
    var replypost:NSDictionary?
    
//    private let post: Post
//    private let user: User
//
    var postID: String?
    
    var postUser: String?

//    init(user: User, post: Post) {
//        self.user = user
//        self.post = post
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replyText.delegate = self
        
        replyingtoUsernameLabel.text = postUser
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
         
         self.databaseRef.child("users/profile").child(uid).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
             let dict = snapshot.value as? [String:Any]
             if(dict!["photoURL"] != nil) {
             
             let databaseProfilePic = dict!["photoURL"] as! String
             
                 if let data = NSData(contentsOf: NSURL(string: databaseProfilePic)! as URL) {
                  
                     self.setProfilePic(imageView: self.userPic,imageToSet:UIImage(data: data as Data)!)

                 }
             }
        }

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func replyButtonTapped(_ sender: Any) {
        guard let postID = postID else { return }
               guard let replyText = replyText.text else { return }
               guard let uid = Auth.auth().currentUser?.uid else { return }
               let creationDate = Int(NSDate().timeIntervalSince1970)
               
               let values = ["replyText": replyText,
                           "creationDate": creationDate,
                           "uid": uid] as [String : Any]
               
               Database.database().reference().child("post-comments").child(postID).childByAutoId().updateChildValues(values)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func cancelButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    internal func setProfilePic(imageView:UIImageView,imageToSet:UIImage) {
        userPic.layer.cornerRadius = imageView.bounds.height / 2
        userPic.layer.masksToBounds = true
        userPic.image = imageToSet
        }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           replyText.becomeFirstResponder()
           
           //Remove the nav shadow underline
           navigationController?.navigationBar.shadowImage = UIImage ()
       }
       
       func textViewDidChange(_ textView: UITextView) {
           replyPlaceHolder.isHidden = !textView.text.isEmpty
       }

}
