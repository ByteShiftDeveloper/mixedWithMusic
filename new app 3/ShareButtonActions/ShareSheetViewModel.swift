//
//  ShareSheetViewModel.swift
//  new app 3
//
//  Created by William Hinson on 10/21/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit

struct ShareSheetViewModel {
    
    private let post: Post
    
    var option: [ShareSheetOptions] {
        var results = [ShareSheetOptions]()
//
//        if user.isCurrentUser {
//            let delete: ShareSheetOptions = .delete(post)
//            results.append(delete)
//        } else {
//            let followOptions: ShareSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
//            results.append(followOptions)
//        }
//
//        results.append(.report)
//      
        return results
    }
    
    init(post: Post) {
        self.post = post
    }
}

enum ShareSheetOptions {
    case follow
    case unfollow
    case report
    case delete(Post)
    
    var description: String {
        switch self {
        case .follow: return "Follow"
        case .unfollow: return "Unfollow"
        case .report: return "Report Post"
        case .delete(let post): return "Delete Post"
        }
    }
    
    var optionsImage: UIImage {
        switch self {
        case .follow: return UIImage(systemName: "person.badge.plus")!
        case .unfollow: return UIImage(systemName: "person.badge.minus")!
        case .report: return UIImage(systemName: "flag")!
        case .delete: return UIImage(systemName: "trash")!
        }
    }
}
