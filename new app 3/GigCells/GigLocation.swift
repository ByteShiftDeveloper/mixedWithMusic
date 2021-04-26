//
//  GigLocation.swift
//  new app 3
//
//  Created by William Hinson on 2/25/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol LocationDelegate: class {
    func handleTap(_ cell: GigLocation)
}

class GigLocation: UITableViewCell {
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Please enter your location"
        label.textColor = .black
        return label
    }()
    
    let location: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Ex: San Antonio, Tx"
        label.textColor = .lightGray
        return label
    }()
    
    var delegate: LocationDelegate?
    
    
 override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
   super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    self.backgroundColor = .clear
    self.contentView.addSubview(locationLabel)
    locationLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 18, paddingLeft: 16)

    self.contentView.addSubview(location)
    location.anchor(top: locationLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    location.addGestureRecognizer(tap)
    location.isUserInteractionEnabled = true
    
    let divider = UIView()
    divider.backgroundColor = .systemGroupedBackground
    self.contentView.addSubview(divider)
    divider.anchor(left: leftAnchor, bottom: bottomAnchor,
                   right: rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, height: 1)
    
//        addSubview(titleTextField)
//        titleTextField.anchor(top: genrelabel.bottomAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)

}
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap() {
        delegate?.handleTap(self)
    }
}
