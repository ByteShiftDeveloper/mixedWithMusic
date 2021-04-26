//
//   SongSearchTVC.swift
//  new app 3
//
//  Created by William Hinson on 10/29/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//


import UIKit

protocol SongSeearchDelegate: class {
    func handleProfileImageTapped(_ cell:SongSearchTVC)
    func didTapFollow(_ cell: SongSearchTVC)
}

class SongSearchTVC: UITableViewCell {
    
    var song: SongPost? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: SongSeearchDelegate?
    
    private lazy var profileImageView: UIImageView = {
           let iv = UIImageView()
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           iv.setDimensions(width: 50, height: 50)
           iv.layer.cornerRadius = 5
           iv.backgroundColor = .lightGray
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
    iv.addGestureRecognizer(tap)
    iv.isUserInteractionEnabled = true
           return iv
       }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Test notification"
        label.textColor = .black
        return label
    }()
    

 

       
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])
        stack.spacing = 8
        stack.alignment = .center
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
//        stack.anchor(right: rightAnchor, paddingRight: 12)
        

//        addSubview(followButton)
//        followButton.centerY(inView: self)
//        followButton.setDimensions(width: 88, height: 32)
//        followButton.layer.cornerRadius = 32 / 2
//        followButton.anchor(right: rightAnchor, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handleFollowTap() {
        delegate?.didTapFollow(self)
    }
    
    func configure() {
        guard let song = song else { return }
        
        profileImageView.loadImage(with: song.coverImage.absoluteString)
        
        notificationLabel.text = song.title
        
//        let viewModel = ExploreViewModel(user: user)
//        followButton.setTitle(viewModel.actionButtonTitle, for: .normal)
//
//        profileImageView.loadImage(with: user.profileImageURL)
//
//        notificationLabel.text = user.fullname
//
//        if user.isVerified != "" {
//            verifiedMark.isHidden = false
//        }
//        if user.isVerified == "" {
//            verifiedMark.isHidden = true
//        }
    }
}
