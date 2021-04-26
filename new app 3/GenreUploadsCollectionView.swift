//
//  GenreUploadsCollectionView.swift
//  new app 3
//
//  Created by William Hinson on 9/9/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Kingfisher

class GenreUploadCollectionView: UICollectionViewCell {
    
 var song: SongPost? {
        didSet {
            guard let url = URL(string: (song?.coverImage.absoluteString)!) else { return }
            coverImage.kf.setImage(with: url)
            titleLabel.text = song?.title
            artistName.text = song?.author.fullname
        }
    }
    
    let coverImage : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    let titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = UIColor(named: "BlackColor")
        lb.font = UIFont.systemFont(ofSize: 16)
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
        return lb
    }()
    
    let artistName: UILabel = {
       let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = UIFont.systemFont(ofSize: 16)
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverImage)
        coverImage.anchor(top: topAnchor, width: 170, height: 170)
        coverImage.centerX(inView: self)

        addSubview(titleLabel)
        titleLabel.anchor(top: coverImage.bottomAnchor, left: coverImage.leftAnchor, right: coverImage.rightAnchor, paddingTop: 2)
        
        addSubview(artistName)
        artistName.anchor(top: titleLabel.bottomAnchor, left: coverImage.leftAnchor, right: coverImage.rightAnchor, paddingTop: -2)
        
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
