//
//  ExploreViewModel.swift
//  new app 3
//
//  Created by William Hinson on 8/12/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct ExploreViewModel {
    
    private let user: User

    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        if !user.isFollowed {
            return "Follow"
        }
        
        if user.isFollowed {
            return "Following"
        }
        
        return "Loading"
    }
    
    var actionButtonColor: UIColor {
        if user.isCurrentUser {
            return .clear
        }
        
        if !user.isFollowed {
            return .clear
        }
        
        if user.isFollowed {
            return .black
        }
        
        return .clear
    }
    
    var actionButtonTitleColor: UIColor {
        if user.isCurrentUser {
            return .black
        }
        
        if !user.isFollowed {
            return .black
        }
        
        if user.isFollowed {
            return .white
        }
        
        return .black
    }
    
    var actionButtonBorderColor: UIColor {
        if user.isCurrentUser {
            return .black
        }
        
        if !user.isFollowed {
            return .black
        }
        
        if user.isFollowed {
            return .clear
        }
        
        return .black
    }
      
      init(user: User) {
          self.user = user

      }
}
