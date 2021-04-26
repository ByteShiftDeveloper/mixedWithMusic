//
//  SearchFilterViewModel.swift
//  new app 3
//
//  Created by William Hinson on 10/29/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import Firebase

enum SearchFilterOptions: Int, CaseIterable {
    case people
    case songs
    case albums
    
    var description: String {
        switch self {
        case .people: return "People"
        case .songs: return "Songs"
        case .albums: return "Albums"
        }
    }
}

struct SearchFilterViewModel {
    
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
        
        if !user.isFollowed && !user.isCurrentUser {
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
