//
//  UserLocationCell.swift
//  new app 3
//
//  Created by William Hinson on 3/3/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol UserLocationDelegate: class {
    func locationSelect(_ cell: UserLocationCell)
}


class UserLocationCell: UITableViewCell {
   
    var delegate: UserLocationDelegate?
    
    var user: User? {
        didSet {
            configureUI()
            
        }
    }

    let chevron: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    
    let titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = UIFont.systemFont(ofSize: 14)
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = "Select your location"
        return lb
    }()
    
    let locationName: UILabel = {
       let lb = UILabel()
        lb.textColor = .black
        lb.font = UIFont.boldSystemFont(ofSize: 14)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
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
        titleLabel.anchor(left: leftAnchor, paddingLeft: 16)
        
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
    
    func configureUI() {
        locationName.text = user?.location
    }

}
