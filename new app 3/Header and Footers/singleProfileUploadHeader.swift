//
//  singleProfileUploadHeader.swift
//  new app 3
//
//  Created by William Hinson on 8/16/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Foundation
import Firebase


class singleProfileUploadHeader: UICollectionReusableView {
    
    let fullnameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Albums and EPs"
        return label
    }()
    
  
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    addSubview(fullnameLabel)
        fullnameLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingLeft: 16)
        fullnameLabel.centerY(inView: self)
        
    let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left: self.leftAnchor, bottom: bottomAnchor,
                            right: rightAnchor, height: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
    

}
