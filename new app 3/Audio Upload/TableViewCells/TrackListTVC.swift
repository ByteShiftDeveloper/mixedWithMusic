//
//  TrackListTVC.swift
//  new app 3
//
//  Created by William Hinson on 7/28/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class TrackListTVC: UITableViewCell {
    
    let featuredArtistLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Track List"
        label.textColor = .black
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Add songs to your track list"
        label.textColor = .black
        return label
    }()
    
    
override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
  super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    self.backgroundColor = .clear
    addSubview(featuredArtistLabel)
    featuredArtistLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)
    
    addSubview(descriptionLabel)
    descriptionLabel.anchor(top: featuredArtistLabel.bottomAnchor, left: self.leftAnchor, paddingTop: 2, paddingLeft: 16)
        
//       addSubview(titleTextField)
//       titleTextField.anchor(top: genrelabel.bottomAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)

}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
