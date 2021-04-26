//
//  Notification.swift
//  new app 3
//
//  Created by William Hinson on 5/26/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case comment
    case repost
    case gigApplication
    case mention
}
struct Notifications {
    var postID: String?
    var timestampt: Date!
    var gigID: String?
    var user: User
    var post: Post?
    var gig: Gigs?
    var type: NotificationType!
    
    init(user: User, dictionary: [String: AnyObject]) {
    self.user = user

        
        if let gigID = dictionary["gigID"] as? String {
            self.gigID = gigID
        }
        
        if let postID = dictionary["postID"] as? String {
            self.postID = postID
        }
        
        if let timestampt = dictionary["timestampt"] as? Double {
            self.timestampt = Date(timeIntervalSince1970: timestampt)
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
