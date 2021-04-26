//
//  FeaturedArtist.swift
//  new app 3
//
//  Created by William Hinson on 7/21/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class FeaturedArtist: UICollectionViewCell {
    
    let featuredArtistLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Featured Artist"
        label.textColor = .white
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Add other artists to your track who aren't you"
        label.textColor = .white
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Artist", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.darkGray
    //       button.addTarget(self, action: #selector(handleFollowTap), for: .touchUpInside)
        return button
    }()
    
override init(frame: CGRect) {
    super.init(frame: frame)
        
    self.backgroundColor = .clear
    addSubview(featuredArtistLabel)
    featuredArtistLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)
    
    addSubview(descriptionLabel)
    descriptionLabel.anchor(top: featuredArtistLabel.bottomAnchor, left: self.leftAnchor, paddingTop: 2, paddingLeft: 16)
    
    addSubview(followButton)
    followButton.anchor(top: descriptionLabel.bottomAnchor, paddingTop: 23, width: 375, height: 50)
    followButton.centerX(inView: self)
        
//       addSubview(titleTextField)
//       titleTextField.anchor(top: genrelabel.bottomAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)

}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
