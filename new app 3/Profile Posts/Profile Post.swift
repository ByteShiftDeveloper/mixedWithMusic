//
//  Profile Post.swift
//  new app 3
//
//  Created by William Hinson on 2/29/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation

class ProfilePost {
    var id:String
       var author:UserProfile
       var text:String
       var picture:String
       var createdAt:Date
       
       
       var peopleWhoLike: [String] = [String]()
       var postID: String!
       
       
       init(id:String, author:UserProfile, text:String, picture:String, timestamp:Double) {
           self.id = id
           self.author = author
           self.text = text
           self.picture = picture
           self.createdAt = Date(timeIntervalSince1970: timestamp / 1000)
       }
       
       static func parse(_ key:String, _ data:[String:Any]) -> ProfilePost? {
           if let author = data["author"] as? [String:Any],
               let uid = author["uid"] as? String,
               let fullname = author["username"] as? String,
               let photoURL = author["photoURL"] as? String,
               let url = URL (string:photoURL),
               let timestamp = data["timestampt"] as? Double {
               
               let text = data["text"] as? String ?? ""
               let picture = data["picture"] as? String ?? ""
               
            
               let userProfile = UserProfile(uid: uid, fullname: fullname, photoURL: url)
               return ProfilePost(id: key, author: userProfile, text: text, picture: picture, timestamp: timestamp)
               
           }
           
           return nil
       }
}
