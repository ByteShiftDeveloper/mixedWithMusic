//
//  GigFilterCell.swift
//  new app 3
//
//  Created by William Hinson on 3/4/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit

class GigFilterCell: UICollectionViewCell {
    
    var option: GigFilterOptions! {
        didSet {
            titleLabel.text = option.description
        }
    }
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Posts"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ?  UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .black : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
