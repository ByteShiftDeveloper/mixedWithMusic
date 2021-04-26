//
//  PostViewModel.swift
//  new app 3
//
//  Created by William Hinson on 5/16/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class PostViewModel {
    let post: Post
    let user: User
    
    
    var retweetsAttributedString: NSAttributedString? {
           return attributedText(withValue: post.retweetCount, text: "Retweets")
       }
       
       var likesAttributedString: NSAttributedString? {
           return attributedText(withValue: post.likes, text: "Likes")
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
