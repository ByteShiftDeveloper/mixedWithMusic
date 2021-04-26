//
//  LocationTVC.swift
//  new app 3
//
//  Created by William Hinson on 3/3/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit

class LocationTVC: UITableViewCell {
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Please enter your location"
        label.textColor = .black
        return label
    }()
        
    
 override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
   super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    self.backgroundColor = .clear
    self.contentView.addSubview(locationLabel)
    locationLabel.centerY(inView: self)
    locationLabel.anchor(left: self.leftAnchor, paddingLeft: 16)

    
//    let divider = UIView()
//    divider.backgroundColor = .systemGroupedBackground
//    self.contentView.addSubview(divider)
//    divider.anchor(left: leftAnchor, bottom: bottomAnchor,
//                   right: rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, height: 1)
    
//        addSubview(titleTextField)
//        titleTextField.anchor(top: genrelabel.bottomAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)

}
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
