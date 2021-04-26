//
//  TrackTitleTVC.swift
//  new app 3
//
//  Created by William Hinson on 7/24/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class TrackTitleTVC: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Track Title"
        label.textColor = .black
        return label
    }()
    
    let titleTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.placeholder = "Enter text here"
        tf.textColor = .black
        return tf
    }()

    
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
  super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
    self.contentView.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)
        
    self.contentView.addSubview(titleTextField)
        titleTextField.anchor(top: titleLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
