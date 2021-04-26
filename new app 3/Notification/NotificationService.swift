//
//  NotificationService.swift
//  new app 3
//
//  Created by William Hinson on 5/26/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import Firebase



struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType, post: Post? = nil, user: User? = nil, gig: Gigs? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var values: [String:Any] = ["timestampt": Int(NSDate().timeIntervalSince1970),
                                    "uid": uid,
                                    "type": type.rawValue]
        if let post = post {
            values["postID"] = post.postID
            REF_NOTIFICATIONS.child(post.user.uid).childByAutoId().updateChildValues(values)
            UNREAD_NOTIFICATIONS_REF.child(post.user.uid).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                guard let count = dictionary["unread"] as? Int else { return }
                print("TRYING TO ADD TO DATABASE")
                let value = count + 1
                UNREAD_NOTIFICATIONS_REF.child(post.user.uid).updateChildValues(["unread": value])
            }
        } else if let user = user {
            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
            UNREAD_NOTIFICATIONS_REF.child(user.uid).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                guard let count = dictionary["unread"] as? Int else { return }
                print("The total amount of unread messages is \(count)")
                let value = count + 1
                UNREAD_NOTIFICATIONS_REF.child(user.uid).updateChildValues(["unread": value])
            }
        } else if let gig = gig {
            REF_NOTIFICATIONS.child(gig.user.uid).childByAutoId().updateChildValues(values)
            UNREAD_NOTIFICATIONS_REF.child(gig.user.uid).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                guard let count = dictionary["unread"] as? Int else { return }
                print("The total amount of unread messages is \(count)")
                let value = count + 1
                UNREAD_NOTIFICATIONS_REF.child(gig.user.uid).updateChildValues(["unread": value])
            }
        }
        
     
    }
    
    func fetchNotifications(completion: @escaping([Notifications]) -> Void) {
        var notifications = [Notifications]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
            guard let dicitonary = snapshot.value as? [String:AnyObject] else { return }
            guard let uid = dicitonary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let notification = Notifications(user: user, dictionary: dicitonary)
                notifications.append(notification)
                completion(notifications)
                
            }
        }
    }
}
