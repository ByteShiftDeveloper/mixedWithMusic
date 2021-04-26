//
//  SubCustomCell2.swift
//  new app 3
//
//  Created by William Hinson on 7/1/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit


class SubCustomCell2: UICollectionViewCell {
    
    var genre = String() {
        didSet {
//            genreView.backgroundColor = genre
//            self.backgroundColor = genre
            titleLabel.text = genre
        }
    }
    
    var color = UIColor() {
        didSet {
            let gradient: CAGradientLayer = CAGradientLayer()
            
            let secondColor = color.withAlphaComponent(0.5)

            gradient.colors = [color.cgColor, secondColor.cgColor]
            gradient.locations = [0.0 , 1.0]
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
            gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)

            self.layer.insertSublayer(gradient, at: 0)
            
            gradient.cornerRadius = 5
            
//            backgroundColor = color
        }
    }
    
    
    
    
   
    
    let titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 16)
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = ""
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
        
        backgroundColor = Colors.genre4
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
        titleLabel.center(inView: self)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor,constant: 10).isActive = true
//        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
//        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        
//        setUpGradientLayer()
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
