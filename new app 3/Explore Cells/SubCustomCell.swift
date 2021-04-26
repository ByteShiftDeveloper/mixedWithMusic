//
//  SubCustomCell.swift
//  new app 3
//
//  Created by William Hinson on 6/28/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Kingfisher

class SubCustomCell: UICollectionViewCell {
    
    var song: SongPost? {
        didSet {
            titleLabel.text = song?.title
            let url = URL(string: (song?.coverImage.absoluteString)!)
            coverImage.kf.setImage(with: url)
//            coverImage.loadImage(with: (song?.coverImage.absoluteString)!)
        }
    }
    
    let coverImage : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .darkGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = UIFont.systemFont(ofSize: 16)
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = ""
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverImage)
        print("user is \(String(describing: song?.author.fullname))")
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        coverImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        coverImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        coverImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        coverImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor,constant: 4).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
