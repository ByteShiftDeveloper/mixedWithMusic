//
//  UserService.swift
//  new app 3
//
//  Created by William Hinson on 12/4/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import Foundation
import Firebase


class UserService {
    
    static let shared = UserService()
    
    static var currentUserProfile:UserProfile?
    
    static func observeUserProfile(_ uid:String, completion: @escaping ((_ UserProfile:UserProfile?)->())) {
        
        let userRef = Database.database().reference().child("users")//.queryEqual(toValue: uid)
        
        userRef.observe(.value, with: {snapshot in
            var userProfile:UserProfile?
            
            let dictArr = snapshot.value as! [String:Any]
            for (key,value) in dictArr{
                let data = value as? [String:Any]
                if key == uid {
                   if let fullname = data!["username"] as? String,
                    let photoURL = data!["photoURL"] as? String,
                    let url = URL (string:photoURL){
                    userProfile = UserProfile(uid: snapshot.key, fullname: fullname, photoURL: url)
                    
                    }
                    
                }
            }
            
//            if let dict = snapshot.value as? [String:Any],
//                let fullname = dict["username"] as? String,
//                let photoURL = dict["photoURL"] as? String,
//                let url = URL (string:photoURL) {
//
//                userProfile = UserProfile(uid: snapshot.key, fullname: fullname, photoURL: url)
//                currentUserProfile = userProfile
//
//            }
            
            completion(userProfile)
        })
    }
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    
   func fetchNewUser(uid: String, completion: @escaping(User) -> Void) {
       REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
           guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                       
           var user = User(uid: uid, dictionary: dictionary)
           
           self.fetchUserStats(uid: user.uid) { stats in
               user.stats = stats
               completion(user)
           }
       }
   }
    
    func fetchUserStats(uid: String, completion: @escaping(UserRelationStats) -> Void) {
           USER_FOLLOWER_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
               let followers = snapshot.children.allObjects.count
               
               USER_FOLLOWING_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
                   let following = snapshot.children.allObjects.count
                   
                   let stats = UserRelationStats(followers: followers, following: following)
                   completion(stats)
               }
           }
       }
    
    func fetchFollowing(uid: String, completion: @escaping(User) -> Void) {
        USER_FOLLOWING_REF.child(uid).observeSingleEvent(of: .childAdded) { snapshot in
            let following = snapshot.children
            print(following)
        }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func fetchUserByUserName(withUsername username: String, completion: @escaping(User) -> Void) {
        REF_USER_USERNAMES.child(username).observeSingleEvent(of: .value) { snapshot in
            guard let uid = snapshot.value as? String else { return }
            self.fetchUser(uid: uid, completion: completion)
        }
    }
    
}
