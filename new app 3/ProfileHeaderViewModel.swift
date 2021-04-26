//
//  ProfileHeaderViewModel.swift
//  new app 3
//
//  Created by William Hinson on 5/8/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import Firebase

enum ProfileFilterOptions: Int, CaseIterable {
    case posts
    case uploads
    case likes
    
    var description: String {
        switch self {
        case .posts: return "Posts"
        case .uploads: return "Uploads"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    var messageButtonColor: UIColor {
        return user.isFollowed ? .black : .lightGray
    }
    
    private let user: User
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: "following")

    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profle"
        }
        //&& !user.isCurrentUser
        if !user.isFollowed  {
            return "Follow"
        }
        
        if user.isFollowed {
            return "Following"
        }
        
        return "Loading"
    }
    
    init(user: User) {
        self.user = user
        
        
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
