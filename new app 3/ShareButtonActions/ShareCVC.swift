//
//  ShareCVC.swift
//  new app 3
//
//  Created by William Hinson on 10/22/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol ShareCVCDelegate: class {
    func handleSelect(_ cell: ShareCVC)
}

class ShareCVC: UICollectionViewCell {
    
    var delegate: ShareCVCDelegate?

    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageURL else { return }
            coverImage.loadImage(with: profileImageUrl)
            
            titleLabel.text = user?.fullname
        }
    }
    
    let coverImage : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .darkGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.numberOfLines = 2
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = ""
        lb.textAlignment = .center
        return lb
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverImage)
//        coverImage.translatesAutoresizingMaskIntoConstraints = false
//        coverImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        coverImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        coverImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        coverImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        coverImage.setDimensions(width: 50, height: 50)
//        coverImage.centerY(inView: self)
//        coverImage.centerX(inView: self)
        coverImage.anchor(top: topAnchor, paddingTop: 8)
        coverImage.centerX(inView: self)
        coverImage.layer.cornerRadius = 50 / 2
//        coverImage.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFilterSelected))
//        coverImage.addGestureRecognizer(tap)

        
        addSubview(titleLabel)
        titleLabel.anchor(top: coverImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor,constant: 8).isActive = true
//        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
//        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    }
