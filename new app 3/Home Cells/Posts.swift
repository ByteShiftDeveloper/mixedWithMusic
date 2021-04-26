//
//  Posts.swift
//  new app 3
//
//  Created by William Hinson on 5/11/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//


import Foundation

class Posts {
    var id:String
    var author:User
    var text:String
    var picture:String
    var createdAt:Date!
    var likes: Int!
    var didLike = false
    
    init(id: String, author: User, dictionary: [String: Any]) {
        self.id = id
        self.author = author
        
        self.text = dictionary["text"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.picture = dictionary["picture"] as? String ?? ""

        if let timestamp = dictionary["timestamp"] as? Double {
            self.createdAt = Date(timeIntervalSince1970: timestamp)
        }
    }
}
