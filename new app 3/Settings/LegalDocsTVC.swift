//
//  LegalDocsTVC.swift
//  new app 3
//
//  Created by William Hinson on 10/21/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class LegalDocsTVC: UITableViewCell {
    
    var viewModel: SettingsViewModel? {
        didSet {
            configure()
        }
    }

    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Edit Profile"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let settingsIcon: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "person")
        iv.tintColor = .black
        iv.setDimensions(width: 25, height: 25)
        return iv
    }()
    
    let rightChevron: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .lightGray
        iv.setDimensions(width: 15, height: 20)
        return iv
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//
        addSubview(settingsIcon)
        settingsIcon.anchor(left: leftAnchor, paddingLeft: 16)
        settingsIcon.centerY(inView: self)
        
        addSubview(titleLabel)
        titleLabel.anchor(left: settingsIcon.rightAnchor, paddingLeft: 8)
        titleLabel.centerY(inView: self)
        
        addSubview(rightChevron)
        rightChevron.anchor(right: rightAnchor, paddingRight: 16)
        rightChevron.centerY(inView: self)
        // Initialization code
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func configure() {
        guard let viewModel = viewModel else { return }

        titleLabel.text = viewModel.titleText
        settingsIcon.image = viewModel.iconImage
//        settingsIcon.image = option?.optionsImage

    }

}
