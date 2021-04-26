//
//  SpotifyActionCell.swift
//  new app 3
//
//  Created by William Hinson on 3/23/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit

class SpotifyActionCell: UICollectionViewCell {
    var user: User? {
        didSet {
            configure()
        }
    }
    
    private var optionImage: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.tintColor = .lightGray
        return iv
    }()
    
     let titleLabel: UITextField = {
       let label = UITextField()
        label.font = UIFont.systemFont(ofSize: 18)
        label.placeholder = "Enter your Spotify Account URL"
        label.textAlignment = .left
        return label
    }()
    
    let containerView : UIView = {
       let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.25
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(optionImage)
        optionImage.centerY(inView: self)
        optionImage.anchor(left: leftAnchor, paddingLeft: 8)
        optionImage.setDimensions(width: 27, height: 27)
        
        contentView.addSubview(containerView)
        containerView.anchor(top:optionImage.topAnchor, left: optionImage.rightAnchor,bottom: bottomAnchor, right: self.rightAnchor, paddingLeft: 12, paddingBottom: 8, paddingRight: 16)
        
        containerView.addSubview(titleLabel)
        titleLabel.anchor(top:containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingLeft: 0, paddingRight: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        if user?.igInfo != "" {
        titleLabel.text = user?.spotifyInfo
        optionImage.image = UIImage(named: "pnghut_social-media-spotify-black-and-white")
        } else{
            titleLabel.text = nil
        }
    }
    
}
