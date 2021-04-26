//
//  Comment.swift
//  new app 3
//
//  Created by William Hinson on 4/17/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    
    var uid: String!
    var replyText: String!
    var creationDate: Date!
    var user: User?
    var commentID: String!
    var didLike = false
    
    init(user: User, dictionary: Dictionary<String, AnyObject>) {
        
        self.user = user
        
        if let uid = dictionary["uid"] as? String {
            self.uid = uid
            }
        
        if let replyText = dictionary["replyText"] as? String {
            self.replyText = replyText
        }
        
        if let creationDate = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: creationDate)
        }
        
        if let commentID = dictionary["commentID"] as? String {
            self.commentID = commentID
        }
    }
}
