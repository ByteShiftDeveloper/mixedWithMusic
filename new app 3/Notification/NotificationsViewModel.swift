//
//  NotificationsViewModel.swift
//  new app 3
//
//  Created by William Hinson on 5/29/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit

struct NotificationViewModel {
    private let notification: Notifications
    private let type: NotificationType
    private let user: User
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestampt, to: now) ?? "2m"
    }

    
    var notificationMessage: String {
        switch type {
            
        case .follow:  return " started following you"
        case .like: return " liked your post"
        case .comment: return " commented on your post"
        case .repost: return " reposted your post"
        case .gigApplication: return " applied to your application"
        case .mention: return " mentioned you in a post"
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else { return nil }
        let attributedText = NSMutableAttributedString(string: user.fullname,
                                                       attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: notificationMessage,
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
        attributedText.append(NSAttributedString(string: " \(timestamp)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
    var profileImageURl: String? {
        return user.profileImageURL
    }
    
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var shouldHideEPKButton: Bool {
        return type != .gigApplication
    }
    
    
    
    var followButtonText: String {
        return user.isFollowed ? "Following" : "Follow"
    }
    
    init(notification: Notifications) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user

    }
}
