
//
//  SongHeader.swift
//  new app 3
//
//  Created by William Hinson on 7/3/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Kingfisher

protocol SongHeaderDelegate: class {
    func handleProfileImageTapped(_ header: SongHeader)
    func handlePlayButtonTapped(_ header: SongHeader)
    func handleNameTap(_ header: SongHeader)
}

class SongHeader: UICollectionReusableView {
    
    weak var delegate: SongHeaderDelegate?
    
    var song: SongPost? {
           
           didSet {
               configure()
           }
       }
    
    var backGroundColor: UIColor?
    
    var gradient: CAGradientLayer!
    
    
//    let imageView : UIImageView = {
//        let iv = UIImageView()
//        iv.clipsToBounds = true
//        iv.contentMode = .scaleAspectFill
//        iv.backgroundColor = .black
//        return iv
//    }()
    
    let backgroundView : UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var coverImage : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 250, height: 250)
        return iv
    }()
    
    let artistName : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.textColor = .white
        lb.text = "Roddy Richh"
        return lb
    }()
    
     let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 50, height: 50)
        iv.layer.cornerRadius = 50 / 2
        iv.backgroundColor = .lightGray
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
//        iv.addGestureRecognizer(tap)
//        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var playPauseButton: UIButton = {
       let button = UIButton()
        button.setTitle("Play", for: .normal)
//        button.layer.borderColor = UIColor.black.cgColor
//        button.layer.borderWidth = 1.25
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    

    
    fileprivate func setUpGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, Colors.blackColor.cgColor]
        gradientLayer.locations = [0.5, 2.0]

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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        gradientLayer.frame = bounds
//
//    }
//
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpGradientLayer()

//        setUpVisualEffectBlur()
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageTap.numberOfTouchesRequired = 1
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        
        playPauseButton.addTarget(self, action: #selector(handlePlayButtonTapped), for: .touchUpInside)

        let nameTap = UITapGestureRecognizer(target: self, action: #selector(handleNameLabelTap))
        nameTap.numberOfTouchesRequired = 1
        artistName.isUserInteractionEnabled = true
        artistName.addGestureRecognizer(nameTap)
    

        
        addSubview(backgroundView)
        backgroundView.fillSuperview()
//        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        addSubview(coverImage)
        coverImage.centerX(inView: self)
        coverImage.centerY(inView: self)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 16, paddingBottom: 16)
        
        addSubview(artistName)
        artistName.anchor(left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, paddingLeft: 16, paddingBottom: 12)
        
        addSubview(playPauseButton)
        playPauseButton.anchor(bottom: profileImageView.bottomAnchor, right: rightAnchor, paddingBottom: 12, paddingRight: 16)
        playPauseButton.setDimensions(width: 80, height: 32)
        playPauseButton.layer.cornerRadius = 32 / 2
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleProfileImageTapped(tapGesture: UITapGestureRecognizer) {
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handlePlayButtonTapped() {
        delegate?.handlePlayButtonTapped(self)
    }
    
    @objc func handleNameLabelTap() {
        delegate?.handleNameTap(self)
    }
    
    
    func configure() {
        
        let profileurl = URL(string: (song?.author.profileImageURL)!)
        profileImageView.kf.setImage(with: profileurl)

        
//        ImageService.getImage(withURL: song!.coverImage) { image in
//            self.coverImage.image = image
//            let backGround = image?.averageColor
//            self.playPauseButton.setTitleColor(backGround, for: .normal)
//            self.backgroundColor = backGround
////            self.backgroundView.backgroundColor = backGround
//
//        }
        
        let coverimageurl = URL(string: (song?.coverImage.absoluteString)!)
        coverImage.kf.setImage(with: coverimageurl)
        let backgroundcolor = coverImage.image?.averageColor
        self.backgroundColor = backgroundcolor
        self.playPauseButton.setTitleColor(backgroundcolor, for: .normal)

//
        
        
//        imageView.loadImage(with: (song?.coverImage.absoluteString)!)
        
        guard let fullname = song?.author.fullname else { return }
        artistName.text = fullname
        
    }
}

