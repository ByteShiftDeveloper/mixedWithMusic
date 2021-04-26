//
//  SubFilterUserCVC.swift
//  new app 3
//
//  Created by William Hinson on 10/29/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol UserFilterDelegate: class {
    func handleSelect(_ cell: SubFilterUserCVC)
}

class SubFilterUserCVC: UICollectionViewCell {
    
    var delegate: UserFilterDelegate?
    
    var genre = String() {
        didSet {
//            genreView.backgroundColor = genre
//            self.backgroundColor = genre
//            titleLabel.text = genre
            filterUserButton.setTitle(genre, for: .normal)
        }
    }
    
    
    let filterUserButton: UIButton = {
       let button = UIButton()
        button.setTitle("Artist", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        
      

        
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.25
        return button
    }()
    

 
    
    fileprivate func setUpGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, Colors.blackColor.cgColor]
        gradientLayer.locations = [0.0, 4.0]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)

        let gradientContainerView = UIView()
        addSubview(gradientContainerView)
        gradientContainerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        gradientContainerView.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = self.bounds
        
        gradientLayer.frame.origin.y -= bounds.height

    }
    
      override func layoutSubviews() {
          super.layoutSubviews()

      }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        setUpGradientLayer()

//        addSubview(genreView)
//        genreView.translatesAutoresizingMaskIntoConstraints = false
//        genreView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        genreView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        genreView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        genreView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        genreView.setGradientBackGround(colorOne: .clear, colorTwo: Colors.blackColor)
//        genreView.layer.cornerRadius = 5
        
        layer.cornerRadius = 5
        
        addSubview(filterUserButton)
        filterUserButton.center(inView: self)
        filterUserButton.setDimensions(width: 180, height: 40)
        filterUserButton.addTarget(self, action: #selector(handleFilterSelected), for: .touchUpInside)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor,constant: 10).isActive = true
//        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
//        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        
//        setUpGradientLayer()
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    @objc func handleFilterSelected() {
        delegate?.handleSelect(self)
    }
}
