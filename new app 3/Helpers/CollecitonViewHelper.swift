//
//  CollecitonViewHelper.swift
//  new app 3
//
//  Created by William Hinson on 1/7/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let width = CGFloat((self.bounds.size.width) - 100)
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}
