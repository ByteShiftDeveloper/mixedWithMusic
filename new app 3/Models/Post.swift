//
//  Post.swift
//  new app 3
//
//  Created by William Hinson on 11/7/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

class Post {
    var id:String
    var author:UserProfile
    var text:String
    var timestamp:Double
    
    init(id:String, author:UserProfile, text:String, timestamp:Double) {
    self.id = id
    self.author = author
    self.text = text
    self.timestamp = timestamp
    
    }
}
