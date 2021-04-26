//
//  SongCollectionViewCell.swift
//  new app 3
//
//  Created by William Hinson on 7/3/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class SongCollectionViewCell: UICollectionViewCell {
    
    var song: SongPost? {
          didSet {
              songTitle.text = song?.title
          }
      }
    
    let songTitle : UILabel = {
       let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.textColor = .black
        return lb
    }()
    
    let songNumber : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.textColor = .lightGray
        return lb
    }()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        
        backgroundColor = .clear
        addSubview(songNumber)
        songNumber.anchor(top: topAnchor, left: leftAnchor, paddingTop: 15, paddingLeft: 16)
        addSubview(songTitle)
        songTitle.anchor(top: topAnchor, left: songNumber.rightAnchor, paddingTop: 15, paddingLeft: 12)
     
        
        let underlineView = UIView()
        underlineView.backgroundColor = .lightGray
        addSubview(underlineView)
        underlineView.anchor(left: songTitle.leftAnchor, bottom: bottomAnchor,
                             right: rightAnchor, height: 0.20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
