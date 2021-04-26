//
//  AudioCollectionReusableView.swift
//  new app 3
//
//  Created by William Hinson on 7/21/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class AudioCollectionReusableView: UICollectionReusableView {
    
    let coverImage:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 150, height: 150)
        iv.backgroundColor = .purple
        return iv
    }()
        
    let addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .lightGray
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
//        button.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
           super.init(frame: frame)
        self.backgroundColor = .red
        
                addSubview(coverImage)
                coverImage.centerY(inView: self)
                coverImage.centerX(inView: self)
        
                addSubview(addImageButton)
                addImageButton.centerY(inView: self)
                addImageButton.centerX(inView: self)
                addImageButton.anchor(width: 25, height: 25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
