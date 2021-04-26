//
//  SocialActionOptions.swift
//  new app 3
//
//  Created by William Hinson on 3/23/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit

struct SocialActionViewModel {
    
    private let user: User
    
    var option: [SocialActionOptions] {
        var results = [SocialActionOptions]()
        
//        if user.isCurrentUser {
//            let delete: SocialActionOptions = .delete(post)
//            results.append(delete)
//        } else {
//            let followOptions: SocialActionOptions = user.isFollowed ? .unfollow(user) : .follow(user)
//            results.append(followOptions)
//        }
//
//        results.append(.report)
        
        return results
    }
    
    init(user: User, post: Post) {
        self.user = user
    }
}

enum SocialActionOptions {
    case igInfo(User)
    case twitterInfo(User)
    case spotifyInfo(User)
    case soundcloudInfo(User)
    
    var description: String {
        switch self {
        case .igInfo(let user): return "Follow \(user.fullname)"
        case .twitterInfo(let user): return "Unfollow \(user.fullname)"
        case .spotifyInfo: return "Report Post"
        case .soundcloudInfo(let post): return "Delete Post"
        }
    }
    
    var optionsImage: UIImage {
        switch self {
        case .follow(_): return UIImage(systemName: "person.badge.plus")!
        case .unfollow(_): return UIImage(systemName: "person.badge.minus")!
        case .report: return UIImage(systemName: "flag")!
        case .delete(_): return UIImage(systemName: "trash")!
        }
    }
}
