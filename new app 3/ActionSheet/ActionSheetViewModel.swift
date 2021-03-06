//
//  ActionSheetViewModel.swift
//  new app 3
//
//  Created by William Hinson on 5/19/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit

struct ActionSheetViewModel {
    
    private let user: User
    private let post: Post
    
    var option: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        
        if user.isCurrentUser {
            let delete: ActionSheetOptions = .delete(post)
            results.append(delete)
        } else {
            let followOptions: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOptions)
        }
        
        results.append(.report)
        
        return results
    }
    
    init(user: User, post: Post) {
        self.user = user
        self.post = post
    }
}

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete(Post)
    
    var description: String {
        switch self {
        case .follow(let user): return "Follow \(user.fullname)"
        case .unfollow(let user): return "Unfollow \(user.fullname)"
        case .report: return "Report Post"
        case .delete(let post): return "Delete Post"
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
