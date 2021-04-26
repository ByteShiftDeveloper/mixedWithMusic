//
//  GigApplyFooterButton.swift
//  new app 3
//
//  Created by William Hinson on 3/5/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit
import Foundation
import Firebase

protocol GigApplyDelegate: class {
    func handleTap(_ cell: GigApplyFooterButton)
}


class GigApplyFooterButton: UICollectionViewCell {
    
    var gigs: Gigs? {
        didSet {
            Service.shared.checkIfUserAppled(gigs!) { didApply in
                guard didApply == true else { return }
                self.gigs?.didApply = true
                self.uploadButton.setTitle("Applied!", for: .normal)
                if self.gigs?.didApply == true {
                    self.uploadButton.isEnabled = false
                }
            }
        }
    }
    weak var delegate: GigApplyDelegate?

    let uploadButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Apply", for: .normal)
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
