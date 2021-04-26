//
//  SettingsOptions.swift
//  new app 3
//
//  Created by William Hinson on 10/21/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit


enum SettingsOptions: Int, CaseIterable {
    case PrivacyPolicy
    case TermsOfUse
    case EndUserLicenseAgreement
    
    var description: String {
        switch self {
        case .PrivacyPolicy: return "Privacy Policy"
        case .TermsOfUse: return "Terms of Use"
        case .EndUserLicenseAgreement: return "End User License Agreement"
        }
    }
    
    var optionsImage: UIImage {
        switch self {
        case .PrivacyPolicy: return UIImage(systemName: "lock")!
        case .TermsOfUse: return UIImage(systemName: "doc.text")!
        case .EndUserLicenseAgreement: return UIImage(systemName: "doc.text")!
        }
    }
}

struct SettingsViewModel {
    private let user: User
    let option: SettingsOptions
    
    
    var titleText: String {
        return option.description
    }
    
    var iconImage: UIImage {
        return option.optionsImage
    }
    
    init(user: User, option: SettingsOptions) {
        self.user = user
        self.option = option
    }
}
