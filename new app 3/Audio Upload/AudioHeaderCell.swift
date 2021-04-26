//
//  AudioHeaderCell.swift
//  new app 3
//
//  Created by William Hinson on 7/22/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol AudioHeaderCellDelegate {
    func handleButtonTap()
}

class AudioHeaderCell: UICollectionViewCell {
    
    var delegate: AudioHeaderCellDelegate?
    
    lazy var coverImage:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 150, height: 150)
        iv.backgroundColor = .darkGray
        return iv
    }()
        
    let addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .lightGray
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(handleImageTap), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
           super.init(frame: frame)
        self.backgroundColor = .clear
        
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
    
    @objc func handleImageTap() {
        delegate?.handleButtonTap()
    }
}
