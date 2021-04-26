//
//  Post.swift
//  new app 3
//
//  Created by William Hinson on 12/4/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import Foundation
import Firebase

class Post {
    var postID:String
    var user:User
    var text:String
    var picture:String
    var songID: String
    var createdAt:Date!
    var video:String
//    var repostedPost: Post
    var likes: Int!
    var didLike = false
    var didComment = false
    var isVerified = false
    var comments: Int!
    var postURL: String
    
//
//    var peopleWhoLike: [String] = [String]()
    
    
    init(postID:String, user:User, dictionary:[String:Any]) {
        self.postID = postID
        self.user = user
        
        self.text = dictionary["text"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.comments = dictionary["comments"] as? Int ?? 0
        self.picture = dictionary["picture"] as? String ?? ""
        self.video = dictionary["video"] as? String ?? ""
        self.songID = dictionary["audio"] as? String ?? ""
        self.postURL = dictionary["url"] as? String ?? ""
//        self.repostedPost = (dictionary["repostedPost"] as? Post)!

        if let createdAt = dictionary["timestampt"] as? Double {
                self.createdAt = Date(timeIntervalSince1970: createdAt)
            }
        }

    
 static func parse(_ key:String, _ data:[String:Any]) -> Post? {
    if let uid = data["uid"] as? String {
//            let fullname = data["username"] as? String,
//            let photoURL = data["photoURL"] as? String,
//            let url = URL (string:photoURL),
//            let timestamp = data["timestampt"] as? Double {
//
//            let likes = data["likes"] as? Int ?? 0
//            let text = data["text"] as? String ?? ""
//            let picture = data["picture"] as? String ?? ""
            
         
            let user = User(uid: uid, dictionary: data)
            return Post(postID: key, user: user, dictionary: data)
            
        }
        
        return nil
    }
    
//    func adjustLikes(addLike: Bool, completion: @escaping(Int) -> ()) {
//
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//
//
//        if addLike {
//
//            USER_LIKES_REF.child(currentUid).updateChildValues([postID: 1]) { (err, ref) in
//
//                POST_LIKES_REF.child(self.postID).updateChildValues([currentUid: 1]) { (err, ref) in
//                    self.likes = self.likes + 1
//                    self.didLike = true
//                    completion(self.likes)
//                    POSTS_REF.child(self.postID).child("likes").setValue(self.likes)
//                }
//
//            }
//
//        } else {
//
//            USER_LIKES_REF.child(currentUid).child(postID).removeValue { (err, ref) in
//                USER_LIKES_REF.child(self.postID).child(currentUid).removeValue { (err, ref) in
//                    guard self.likes > 0 else { return }
//                    self.likes = self.likes - 1
//                    self.didLike = false
//                    completion(self.likes)
//                    POSTS_REF.child(self.postID).child("likes").setValue(self.likes)
//                }
//            }
//        }
//    }
}
