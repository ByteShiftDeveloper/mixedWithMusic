//
//  FilterFooter.swift
//  new app 3
//
//  Created by William Hinson on 10/29/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol FilterFooterDelegate: class {
    func handleDismiss(_ footer: FilterFooter)
}

class FilterFooter: UICollectionReusableView {
    
    var delegate: FilterFooterDelegate?

    lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
       // button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()


        
  override init(frame: CGRect) {
      super.init(frame: frame)
      
    addSubview(applyButton)
    applyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    applyButton.anchor(left: leftAnchor, right: rightAnchor,
                        paddingLeft: 12, paddingRight: 12)
    applyButton.centerY(inView: self)
    applyButton.layer.cornerRadius = 50 / 2
    applyButton.applyGradient(colors: [UIColor.black.cgColor, Colors.space.cgColor])
      
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
