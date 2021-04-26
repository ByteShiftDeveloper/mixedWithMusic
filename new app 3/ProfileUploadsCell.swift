//
//  ProfileUploadsCell.swift
//  new app 3
//
//  Created by William Hinson on 8/15/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import SkeletonView

class ProfileUploadsCell: UICollectionViewCell {
    
    var song: SongPost? {
        didSet {
            guard let streams = song?.streams else { return }
            titleLabel.text = song?.title
            coverImage.loadImage(with: (song?.coverImage.absoluteString)!)
            streamsLabel.text = "\(streams) streams"
        }
    }
    
    let coverImage : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .darkGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 3
        return iv
    }()
    
    let titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .black
        lb.font = UIFont.boldSystemFont(ofSize: 16)
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = ""
        return lb
    }()
    
    let streamsLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.text = ""
        return lb
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverImage)
        coverImage.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 2.5 ,paddingLeft: 16, width: 50, height: 50)
//        coverImage.centerY(inView: self)
        
        coverImage.layer.shadowColor = UIColor.black.cgColor
        coverImage.layer.shadowRadius = 50
        coverImage.layer.shadowOpacity = 0.5
        coverImage.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        coverImage.isSkeletonable = true

        addSubview(titleLabel)
        titleLabel.anchor(left: coverImage.rightAnchor, paddingLeft: 16)
        titleLabel.centerY(inView: self)
        
        addSubview(streamsLabel)
        streamsLabel.anchor(right: rightAnchor, paddingRight: 16)
        streamsLabel.centerY(inView: self)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left: titleLabel.leftAnchor, bottom: bottomAnchor,
                             right: rightAnchor, height: 1)

      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
