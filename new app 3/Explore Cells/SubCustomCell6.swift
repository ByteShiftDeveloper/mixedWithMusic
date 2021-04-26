//
//  SubCustomCell6.swift
//  new app 3
//
//  Created by William Hinson on 2/26/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit
import Kingfisher

protocol subCustom6Delegate: class {
    func buttonTapped(_ cell: SubCustomCell6)
}

class SubCustomCell6: UICollectionViewCell {
    
    var delegate: subCustom6Delegate?
    
    var gig: Gigs? {
        didSet {
            
            let url = URL(string: (gig?.user.profileImageURL)!)
            coverImage.kf.setImage(with: url)
            
            if gig?.user.headerImageURL == nil {
                let headerImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/mixed-with-music-28704.appspot.com/o/users%2Fprofile%2FStandard%20Header%2FDeep%20Space.jpg?alt=media&token=ccf92ddb-604a-45a2-9e6c-8d21029c726f")
                headerImage.kf.setImage(with: headerImageUrl)

            } else if gig?.user.headerImageURL != nil {
                let headerImageUrl = URL(string: (gig?.user.headerImageURL)!)
                headerImage.kf.setImage(with: headerImageUrl)

            }
            titleLabel.text = gig?.user.fullname
            amdpLabel.text = gig?.user.location
//            cityStateLabel.text = user!.city + "," + user!.state
            bioLabel.text = gig?.title
            
            Service.shared.checkIfUserAppled(gig!) { didApply in
                guard didApply == true else { return }
                self.gig?.didApply = true
                self.followButton.setTitle("Applied!", for: .normal)
                if self.gig?.didApply == true {
                    self.followButton.isEnabled = false
                }
            }

            
//            if user?.isVerified == "" {
//                verifiedMark.isHidden = true
//            }
            
        }
    }
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.75
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    
    let coverImage : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .darkGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3.0
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    
    let headerImage : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .darkGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return iv
    }()

    
    let titleLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = UIColor(named: "BlackColor")
//        lb.font = UIFont.systemFont(ofSize: 16)
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.text = ""
        lb.textAlignment = .center
        lb.numberOfLines = 2
        return lb
    }()
    
    let amdpLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .lightGray
        lb.font = UIFont.systemFont(ofSize: 14)
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = ""
        lb.textAlignment = .center
        lb.numberOfLines = 2
        return lb
    }()
    
    let cityStateLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = UIColor(named: "BlackColor")
        lb.font = UIFont.systemFont(ofSize: 14)
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = ""
//        lb.textAlignment = .center
        lb.numberOfLines = 1
        return lb
    }()
    
    let bioLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = UIColor(named: "BlackColor")
        lb.font = UIFont.boldSystemFont(ofSize: 16)
//        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.text = ""
        lb.textAlignment = .center
        lb.numberOfLines = 2
        return lb
    }()
    
    private let verifiedMark: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark.seal.fill")
        iv.tintColor = UIColor(named: "BlackColor")
        iv.setDimensions(width: 20, height: 18)
        return iv
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "BlackColor")
//        button.layer.borderColor = UIColor.black.cgColor
//        button.layer.borderWidth = 1.25
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
      
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        
        containerView.addSubview(headerImage)
        headerImage.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, height: 56)
        
        containerView.addSubview(coverImage)
        coverImage.setDimensions(width: 80, height: 80)
        coverImage.anchor(top: containerView.topAnchor, paddingTop: 16)
        coverImage.centerX(inView: containerView)
        coverImage.layer.cornerRadius = 80 / 2
        
    

        let stack = UIStackView(arrangedSubviews: [ titleLabel ])
        verifiedMark.setDimensions(width: 20, height: 18)
        stack.spacing = 0
        stack.distribution = .fill
        stack.alignment = .center
        containerView.addSubview(stack)
        stack.anchor(top: coverImage.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingRight: 8)
        stack.centerX(inView: containerView)
        
        
        containerView.addSubview(amdpLabel)
        amdpLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 8)
        amdpLabel.centerX(inView: containerView)

        
        containerView.addSubview(bioLabel)
        bioLabel.anchor(top: amdpLabel.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 8)
        bioLabel.centerX(inView: containerView)
        
        containerView.addSubview(followButton)
        followButton.centerX(inView: containerView)
        followButton.setDimensions(width: 150, height: 32)
        followButton.layer.cornerRadius = 32 / 2
        followButton.anchor(bottom: containerView.bottomAnchor, paddingBottom: 12)
        followButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        followButton.applyGradient(colors: [UIColor.black.cgColor, Colors.space.cgColor])

        
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    @objc func buttonTap() {
        delegate?.buttonTapped(self)
    }
}
