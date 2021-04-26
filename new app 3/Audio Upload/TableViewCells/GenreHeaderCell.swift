//
//  GenreHeaderCell.swift
//  new app 3
//
//  Created by William Hinson on 7/22/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class GenreHeaderCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "Music Genre"
        label.textColor = .black
        return label
    }()
    
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
    self.contentView.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
