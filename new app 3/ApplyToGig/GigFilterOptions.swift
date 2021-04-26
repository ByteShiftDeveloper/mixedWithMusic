//
//  GigFilterOptions.swift
//  new app 3
//
//  Created by William Hinson on 3/4/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import Foundation

enum GigFilterOptions: Int, CaseIterable {
    case gigs
    
    var description: String {
        switch self {
        case .gigs: return "Gigs"
        }
    }
}
