//
//  ShareFooter.swift
//  new app 3
//
//  Created by William Hinson on 10/23/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol ShareFooterDelegate: class {
    func handleDismiss(_ footer: ShareFooter)
}

class ShareFooter: UICollectionReusableView {
    
    var delegate: ShareFooterDelegate?

    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()


        
  override init(frame: CGRect) {
      super.init(frame: frame)
      
    addSubview(cancelButton)
    cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    cancelButton.anchor(left: leftAnchor, right: rightAnchor,
                        paddingLeft: 12, paddingRight: 12)
    cancelButton.centerY(inView: self)
    cancelButton.layer.cornerRadius = 50 / 2
      
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
    
    @objc func handleDismiss() {
        delegate?.handleDismiss(self)
    }
}
