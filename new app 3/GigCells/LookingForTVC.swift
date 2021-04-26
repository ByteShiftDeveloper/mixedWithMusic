//
//  LookingForTVC.swift
//  new app 3
//
//  Created by William Hinson on 2/24/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit
import DropDown

protocol LookingForDelegate: class {
    func handleTap(_ cell: LookingForTVC)
}

class LookingForTVC: UITableViewCell {
    
   weak var delegate: LookingForDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "What are you looking for?"
        label.textColor = .black
        return label
    }()
    
    let titleTextField: UILabel = {
        let tf = UILabel()
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.text = "Select a category"
        tf.textColor = .lightGray
        return tf
    }()
    
    let dropDownaButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let divider = UIView()
    
    let menu: DropDown = {
       let menu = DropDown()
        menu.dataSource = ["Artist", "Band", "DJ", "Musician", "Producer"]
        return menu
    }()
   
    
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
  super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
    self.contentView.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 18, paddingLeft: 16)
        
    self.contentView.addSubview(titleTextField)
        titleTextField.anchor(top: titleLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
    
    self.contentView.addSubview(dropDownaButton)
    dropDownaButton.anchor(top: titleLabel.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 24, width: 15, height: 10)
    dropDownaButton.isUserInteractionEnabled = true
    dropDownaButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    
    divider.backgroundColor = .systemGroupedBackground
    self.contentView.addSubview(divider)
    divider.anchor(left: leftAnchor, bottom: bottomAnchor,
                   right: rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, height: 1)
    
    menu.anchorView = divider
    menu.selectionAction = { [weak self] (index, item) in
        self?.titleTextField.text = item
        self?.titleTextField.textColor = .black
    }
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap() {
        delegate?.handleTap(self)
    }
}
