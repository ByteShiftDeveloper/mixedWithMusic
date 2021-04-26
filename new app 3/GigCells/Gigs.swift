//
//  Gigs.swift
//  new app 3
//
//  Created by William Hinson on 2/26/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import Foundation
import Firebase

class Gigs {
    var GigId:String
    var user:User
    var text:String
    var lookingFor:String
    var title:String
    var location:String
    var genre:String
    var time: String
    var applications:Int!
    var didApply = false
    var createdAt:Date!
    
    
    
    init(GigId:String, user:User, dictionary:[String:Any]) {
        self.GigId = GigId
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.lookingFor = dictionary["lookingFor"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.genre = dictionary["genre"] as? String ?? ""
        self.time = dictionary["eventTime"] as? String ?? ""
        self.applications = dictionary["applications"] as? Int ?? 0
        if let createdAt = dictionary["timestampt"] as? Double {
                self.createdAt = Date(timeIntervalSince1970: createdAt)
            }
        }
}
