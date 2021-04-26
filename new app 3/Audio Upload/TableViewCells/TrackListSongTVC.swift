//
//  TrackListSongTVC.swift
//  new app 3
//
//  Created by William Hinson on 7/28/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import UIKit

class TrackListSongTVC: UITableViewCell {
    
    let trackNumber: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "1"
        label.textColor = .black
        return label
    }()
    
    let songName: UILabel = {
           let label = UILabel()
           label.numberOfLines = 1
           label.font = UIFont.systemFont(ofSize: 20)
           label.text = "Song Name"
           label.textColor = .black
           return label
       }()
    
    let chevronImage: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
  super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    self.backgroundColor = .clear
    
    self.contentView.addSubview(trackNumber)
    trackNumber.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 14, paddingLeft: 16)
    
    self.contentView.addSubview(songName)
    songName.anchor(top: self.topAnchor, left: trackNumber.rightAnchor, paddingTop: 14, paddingLeft: 24)
    
    self.contentView.addSubview(chevronImage)
    chevronImage.anchor(top: self.topAnchor, right: self.rightAnchor, paddingTop: 8, paddingRight: 16, width: 16, height: 32.5)
    chevronImage.tintColor = .white
}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
