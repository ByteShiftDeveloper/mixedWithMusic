//
//  GigTitle.swift
//  new app 3
//
//  Created by William Hinson on 3/4/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit



class GigTitle: UITableViewCell {
    
    let gigTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.text = "Give your gig listing a title"
        label.textColor = .black
        return label
    }()
    
    let gigTextView: UITextField = {
       let text = UITextField()
        text.placeholder = "Ex: Musician wanted for live music!"
        text.textColor = .black
        text.font = UIFont.systemFont(ofSize: 16)
        text.returnKeyType = .done
        return text
    }()
    
    
    
 override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
   super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    addSubview(gigTitle)
    gigTitle.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
    
    contentView.addSubview(gigTextView)
    gigTextView.anchor(top: gigTitle.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)
    
    let divider = UIView()
    divider.backgroundColor = .systemGroupedBackground
    addSubview(divider)
    divider.anchor(top: gigTextView.bottomAnchor, left: leftAnchor,
                   right: rightAnchor, paddingTop: 2, paddingLeft: 16, paddingRight: 16, height: 1)
//        addSubview(titleTextField)
//        titleTextField.anchor(top: genrelabel.bottomAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)

}
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
