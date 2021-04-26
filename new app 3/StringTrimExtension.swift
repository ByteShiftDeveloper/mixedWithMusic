//
//  StringTrimExtension.swift
//  new app 3
//
//  Created by William Hinson on 5/20/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation

extension String {

    func trim(to maximumCharacters: Int) -> String {
        return "\(self[..<index(startIndex, offsetBy: maximumCharacters)])" + "..."
    }
}
