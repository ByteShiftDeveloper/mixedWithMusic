//
//  UserProfile.swift
//  new app 3
//
//  Created by William Hinson on 12/4/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import Foundation

class UserProfile {
    var uid: String
    var fullname: String
    var photoURL: URL
    
    init(uid:String, fullname: String, photoURL:URL){
        self.uid = uid
        self.fullname = fullname
        self.photoURL = photoURL
    }
}
