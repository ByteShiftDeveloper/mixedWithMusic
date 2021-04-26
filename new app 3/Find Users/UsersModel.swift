//
//  UsersModel.swift
//  new app 3
//
//  Created by William Hinson on 1/9/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation

class Users {
    var author:UserProfile
    var artistDJBand:String
    
    
    init(author:UserProfile, artistDJBand:String) {
        self.author = author
        self.artistDJBand = artistDJBand
    
    }
    
//    static func parse(_ key:String, _ data:[String:Any]) -> Users? {
//        if let author = data["author"] as? [String:Any],
//            let uid = author["uid"] as? String,
//            let fullname = author["username"] as? String,
//            let photoURL = author["photoURL"] as? String,
//            let url = URL (string:photoURL),
//            let artistDJBand = author["What do you consider yourself?"] as? String {
//            
//            
//         
//            let userProfile = UserProfile(uid: uid, fullname: fullname, photoURL: url)
//            return Users(author: userProfile, artistDJBand: artistDJBand)
//            
//        }
//        
//        return nil
//    }
}
