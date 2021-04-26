//
//  ShareHeader.swift
//  new app 3
//
//  Created by William Hinson on 10/22/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class ShareHeader: UICollectionReusableView {

  let titleLabel: UILabel = {
     let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 16)
      label.text = "Send To"
    label.textColor = .darkGray
      return label
  }()


        
  override init(frame: CGRect) {
      super.init(frame: frame)
      
    addSubview(titleLabel)
    titleLabel.centerY(inView: self)
    titleLabel.centerX(inView: self)
      
//      let underlineView = UIView()
//          underlineView.backgroundColor = .systemGroupedBackground
//          addSubview(underlineView)
//          underlineView.anchor(left: self.leftAnchor, bottom: bottomAnchor,
//                              right: rightAnchor, height: 1)
//
//      }
}

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
