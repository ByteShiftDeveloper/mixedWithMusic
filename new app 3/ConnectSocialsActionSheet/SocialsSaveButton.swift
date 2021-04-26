//
//  SocialsSaveButton.swift
//  new app 3
//
//  Created by William Hinson on 3/24/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit
import Foundation
import Firebase

protocol SocialsSaveButtonDelegate: class {
    func handleTap(_ cell: SocialsSaveButton)
}


class SocialsSaveButton: UICollectionViewCell {
    
  
    weak var delegate: SocialsSaveButtonDelegate?

    let uploadButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Save", for: .normal)
      button.setTitleColor(.white, for: .normal)
      button.backgroundColor = Colors.blackColor
      button.layer.cornerRadius = 25
      button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
      return button
      }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        configureUI()

        self.contentView.addSubview(uploadButton)
        uploadButton.centerX(inView: self)
        uploadButton.centerY(inView: self)
        uploadButton.anchor(width: 375, height: 50)
        uploadButton.applyGradient(colors: [UIColor.black.cgColor, Colors.space.cgColor])
        uploadButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleTap() {
        delegate?.handleTap(self)
    }
    
    func configureUI() {
        
        
    }
}
