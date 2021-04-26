//
//  SelectyourgenresTVC.swift
//  new app 3
//
//  Created by William Hinson on 10/19/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class SelectyourgenresTVC: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Genre"
        label.textColor = .black
        return label
    }()
    
    lazy var selectGenreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
//        button.contentVerticalAlignment = .fill
//        button.contentHorizontalAlignment = .fill
        button.backgroundColor = .clear
        button.tintColor = .black
    //       button.addTarget(self, action: #selector(handleFollowTap), for: .touchUpInside)
        return button
    }()
    
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    self.backgroundColor = .clear
    self.contentView.addSubview(titleLabel)
    titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 11, paddingLeft: 16)
    titleLabel.centerX(inView: self)
    
    self.contentView.addSubview(selectGenreButton)
    selectGenreButton.anchor(top: self.topAnchor, right: self.rightAnchor, paddingTop: 11, paddingRight: 16)
//    selectGenreButton.centerX(inView: self)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
