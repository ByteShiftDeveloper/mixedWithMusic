//
//  PostViewModel.swift
//  new app 3
//
//  Created by William Hinson on 5/12/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

struct PostViewModel {
    
    let post: Post
    let user: User
    
    
//    var likeButtonTintColor: UIColor {
//        if post.didLike == true {
//            return .red
//        }
//            return .black
//    }
        
//    var likeButtonImage: UIImage {
//        if post.didLike == true {
//            let imageName = "heart"
//            return UIImage(named: imageName)!
//        }
//        let imageName = "heart_unfilled"
//        return UIImage(named: imageName)!
//    }
    
    var likeButtonImage: UIImage {
        let imageName = post.didLike ? "heart filled 2" : "heart unfilled"
        return UIImage(named: imageName)!
    }
    
    var likeButtonTintColor: UIColor {
        return post.didLike ? Colors.fbLightBlue : Colors.blackColor// "HeartColor" : "BlackColor"
       // return UIColor(named: colorName)!
    }
    
    
    init(post: Post) {
          self.post = post
          self.user = post.user
      }
    
//    var repostsAttributedString: NSAttributedString? {
//           return attributedText(withValue: post.repostCount, text: "Reposts")
//       }
       
       var likesAttributedString: NSAttributedString? {
           return attributedText(withValue: post.likes, text: "Likes")
       }
    
    var commentsAttributedString: NSAttributedString? {
        return attributedText(withValue: post.comments, text: "Comments")
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                               .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
