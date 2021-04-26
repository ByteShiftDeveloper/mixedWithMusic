//
//  currentUser.swift
//  new app 3
//
//  Created by William Hinson on 11/20/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import Foundation

struct CurrentUser {
    let uid: String
    let name: String
    let email: String
    let profilePictureURL: String
    
    init(uid: String, dictionary: [String:Any]) {
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profilePictureURL = dictionary["profilePictureURL"] as? String ?? ""

    }
}
