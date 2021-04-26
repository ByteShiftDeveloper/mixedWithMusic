//
//  UserService.swift
//  new app 3
//
//  Created by William Hinson on 11/21/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import Foundation
import Firebase

class UserService {

    static var currentUserProfile:UserProfile?
    
    
    static func observeUserProfile(_ uid:String, completion: @escaping ((_ UserProfile:UserProfile?)->())) {
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile:UserProfile?
            
            if let dict = snapshot.value as? [String:Any],
                let username = dict["username"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let url = URL(string:photoURL){
                
                userProfile = UserProfile(uid: snapshot.key, fullname: username, photoURL: url)
            }
            
            completion(userProfile)
        })
    }
}
