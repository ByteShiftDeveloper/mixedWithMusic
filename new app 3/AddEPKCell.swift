//
//  AddEPKCell.swift
//  new app 3
//
//  Created by William Hinson on 3/26/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol AddEPKDelegate: class {
    func handleEPKTap(_ cell: AddEPKCell)
}

class AddEPKCell: UITableViewCell {
   
    
//    var user: User? {
//        didSet {
////            configureUI()
//
//        }
//    }
    
    var delegate: AddEPKDelegate?

//    let chevron: UIButton = {
//       let button = UIButton()
//        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//        button.tintColor = .lightGray
//        return button
//    }()
    
    
    let titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .black
        lb.font = UIFont.boldSystemFont(ofSize: 16)
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = "Click here to add your EPK!"
        return lb
    }()
    
    let chevron: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .clear
        return button
    }()


    let pdfLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .darkGray
        lb.font = UIFont.systemFont(ofSize: 14)
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = ""
        return lb
    }()
    
//    let locationName: UILabel = {
//       let lb = UILabel()
//        lb.textColor = .black
//        lb.font = UIFont.boldSystemFont(ofSize: 14)
////        lb.font = UIFont.boldSystemFont(ofSize: 20)
//        lb.text = "Any"
//        return lb
//    }()
//

 
    
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
        
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, paddingTop: 16)
        titleLabel.centerX(inView: self)
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(epkLabelTap))
        nameTap.numberOfTouchesRequired = 1
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(nameTap)
       
        
        addSubview(pdfLabel)
        pdfLabel.centerX(inView: self)
        pdfLabel.anchor(bottom: bottomAnchor, paddingBottom: 8)

        addSubview(chevron)
        chevron.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 8, paddingRight: 8)
        
//        addSubview(chevron)
//        chevron.centerY(inView: self)
//        chevron.anchor(right: rightAnchor, paddingRight: 8)
//
//        addSubview(locationName)
//        locationName.centerY(inView: self)
//        locationName.anchor(right: chevron.leftAnchor, paddingRight: 8)
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
    
    @objc func epkLabelTap() {
        delegate?.handleEPKTap(self)
    }
    
 
    
//    func configureUI() {
//        locationName.text = user?.location
//    }

}
