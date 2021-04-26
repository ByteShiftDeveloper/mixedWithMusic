//
//  ShareSheetCell.swift
//  new app 3
//
//  Created by William Hinson on 10/21/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class ShareSheetCell: UITableViewCell {
    var option: ShareSheetOptions? {
        didSet {
            configure()
        }
    }
    
    private var optionImage: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.tintColor = .lightGray
        return iv
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test Options"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(optionImage)
        optionImage.centerY(inView: self)
        optionImage.anchor(left: leftAnchor, paddingLeft: 8)
        optionImage.setDimensions(width: 27, height: 27)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: optionImage.rightAnchor, paddingLeft: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        titleLabel.text = "Random Text"
//        optionImage.image = option?.optionsImage
    }
}
