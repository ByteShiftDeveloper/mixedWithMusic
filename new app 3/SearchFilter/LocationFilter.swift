//
//  LocationFilter.swift
//  new app 3
//
//  Created by William Hinson on 10/29/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol LocationFilterDelegate: class {
    func locationSelect(_ cell: LocationFilter)
}


class LocationFilter: UICollectionViewCell {
   
    var delegate: LocationFilterDelegate?
    
    

    let chevron: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    
    let titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .black
        lb.font = UIFont.boldSystemFont(ofSize: 16)
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = "Location"
        return lb
    }()
    
    let locationName: UILabel = {
       let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = UIFont.systemFont(ofSize: 16)
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = "Any"
        return lb
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
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: leftAnchor, paddingLeft: 8)
        
        addSubview(chevron)
        chevron.centerY(inView: self)
        chevron.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(locationName)
        locationName.centerY(inView: self)
        locationName.anchor(right: chevron.leftAnchor, paddingRight: 8)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor,constant: 10).isActive = true
//        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
//        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        self.contentView.addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor,
                             right: rightAnchor, height: 1)
        
//        setUpGradientLayer()
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    @objc func handleLocationSelect() {
        delegate?.locationSelect(self)
    }

}
