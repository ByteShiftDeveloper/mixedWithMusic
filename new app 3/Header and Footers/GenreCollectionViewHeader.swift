//
//  GenreCollectionViewHeader.swift
//  new app 3
//
//  Created by William Hinson on 8/27/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class GenreCollectionViewHeader: UICollectionReusableView {
    
        var genre = String() {
                didSet {
        //            genreView.backgroundColor = genre
        //            self.backgroundColor = genre
                    genreLabel.text = genre
                }
            }
            
            var color = UIColor() {
                didSet {
                    backgroundColor = color
                }
            }
    
      let genreLabel: UILabel = {
         let label = UILabel()
          label.font = UIFont.boldSystemFont(ofSize: 30)
          label.text = "Albums and EPs"
        label.textColor = .white
          return label
      }()
    
    let backgroundView : UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    fileprivate func setUpGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, Colors.blackColor.cgColor]
        gradientLayer.locations = [0.0, 3.0]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)

        let gradientContainerView = UIView()
        addSubview(gradientContainerView)
        gradientContainerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        gradientContainerView.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = self.bounds
        
        gradientLayer.frame.origin.y -= bounds.height

    }

    fileprivate func setUpVisualEffectBlur() {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)

        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
    }
    
          
      override init(frame: CGRect) {
          super.init(frame: frame)
          
      addSubview(genreLabel)
        genreLabel.anchor(bottom: self.bottomAnchor, paddingBottom: 20)
          genreLabel.centerX(inView: self)
        
        addSubview(backgroundView)
        backgroundView.fillSuperview()
          
//        setUpGradientLayer()
        
          
//      let underlineView = UIView()
//          underlineView.backgroundColor = .systemGroupedBackground
//          addSubview(underlineView)
//          underlineView.anchor(left: self.leftAnchor, bottom: bottomAnchor,
//                              right: rightAnchor, height: 1)
//
//      }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
