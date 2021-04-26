//
//  UsersProfileViewController.swift
//  new app 3
//
//  Created by William Hinson on 1/20/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class UsersProfileViewController: UIViewController {
    
    var loggedInUser:User?
    var otherUser:NSDictionary?
    var databaseRef:DatabaseReference!
    var loggedInUserData:NSDictionary?
    
    @IBOutlet weak var followButton: FollowButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var artistBandDJ: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profilePIc: UIImageView!
    
    @IBOutlet weak var headerPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tabBar = self.tabBarController?.tabBar else { return }
                      
                      tabBar.tintColor = UIColor.black
                      tabBar.barTintColor = UIColor.white
        
        guard let userkey = Auth.auth().currentUser?.uid else {return}
        self.databaseRef = Database.database().reference()
        
        databaseRef.child("users/profile").child(userkey).observe(.value, with: { (snapshot) in
            
            self.loggedInUserData = snapshot.value as? NSDictionary
            
            self.loggedInUserData?.setValue(userkey, forKey: "uid")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        databaseRef.child("users/profile").child(self.otherUser?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            let uid = self.otherUser?["uid"] as! String
            self.otherUser = snapshot.value as? NSDictionary
            self.otherUser?.setValue(uid, forKey: "uid")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        databaseRef.child("following").child(userkey).child(self.otherUser?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            if(snapshot.exists()){
                self.followButton.setTitle("Following", for: .normal)
            }
            else {
                self.followButton.setTitle("Follow", for: .normal)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.usernameLabel.text = self.otherUser?["name"] as? String
        self.artistBandDJ.text = self.otherUser?["What do you consider yourself?"] as? String
        self.profilePIc.image = self.otherUser?["photoURL"] as? UIImage
        self.headerPic.image = self.otherUser?["headerURL"] as? UIImage
        
    }
    
    @IBAction func backButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapFollow(_ sender: Any) {
        
        
        
        
        let followersRef = "followers/\(self.otherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
        let followingRef = "following/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.otherUser?["uid"] as! String)
        
        if(self.followButton.titleLabel?.text == "Follow"){
            let followersData = ["username":self.loggedInUserData?["username"] as! String,
                                 "photoURL":"\(self.loggedInUserData?["photoURL"])"]
            
            let followingData = ["username":self.otherUser?["username"] as! String,
            "photoURL":"\(self.otherUser?["photoURL"])"]
            
            let childUpdates = [followersRef:followersData,
                                followingRef:followingData]
            
            databaseRef.updateChildValues(childUpdates)
            
            let followersCount:Int?
            let followingCount:Int?
            
            if(self.otherUser?["followersCount"] == nil) {
                followersCount = 1
            }
            else
            {
                followersCount = self.otherUser?["followersCount"] as! Int + 1
            }
            
            if(self.loggedInUserData?["followingCount"] == nil) {
                followingCount = 1
            }
            else
            {
                followingCount = self.loggedInUserData?["followingCount"] as! Int + 1
            }
            
            databaseRef.child("users/profile").child(self.loggedInUserData?["uid"] as! String).child("followingCount").setValue(followingCount)
            
            databaseRef.child("users/profile").child(self.loggedInUserData?["uid"] as! String).child("followersCount").setValue(followersCount)
            
        }
        else
        {
            
            databaseRef.child("users/profile").child(self.loggedInUserData?["uid"] as! String).child("followingCount").setValue(self.loggedInUserData!["followingCount"] as! Int - 1)
            
            databaseRef.child("users/profile").child(self.loggedInUserData?["uid"] as! String).child("followersCount").setValue(self.loggedInUserData!["followersCount"] as! Int - 1)
            
            let followersRef = "followers/\(self.otherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
            let followingRef = "following/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.otherUser?["uid"] as! String)
            
            let childUpdates = [followingRef:NSNull(), followersRef:NSNull()]
            
            databaseRef.updateChildValues(childUpdates)
            
        }
    }
    
}

