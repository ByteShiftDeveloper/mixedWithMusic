//
//  GigApplyFooter.swift
//  new app 3
//
//  Created by William Hinson on 3/5/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit
import Foundation
import Firebase

protocol GigAppleDelegate: class {
    func handleTap(_ header: GigApplyFooter)
}


class GigApplyFooter: UICollectionReusableView {
  

    weak var delegate: GigAppleDelegate?

    let uploadButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Post Gig", for: .normal)
      button.setTitleColor(.white, for: .normal)
      button.backgroundColor = Colors.blackColor
      button.layer.cornerRadius = 25
         button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
      return button
      }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(uploadButton)
        uploadButton.centerX(inView: self)
        uploadButton.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleTap() {
        delegate?.handleTap(self)
    }
}
