//
//  NotificationsCell.swift
//  new app 3
//
//  Created by William Hinson on 5/29/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Kingfisher

protocol NotificationCellDelegate: class {
    func handleProfileImageTapped(_ cell:NotificationsCell)
    func followTap(_ cell: NotificationsCell)
    func epkTap(_ cell: NotificationsCell)
}

class NotificationsCell: UITableViewCell {
    
    var notification: Notifications? {
        didSet { configure()
            checkUserIsFollowed()
        }
    }
    
    var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
           let iv = UIImageView()
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           iv.setDimensions(width: 50, height: 50)
           iv.layer.cornerRadius = 50 / 2
           iv.backgroundColor = .lightGray
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
    iv.addGestureRecognizer(tap)
    iv.isUserInteractionEnabled = true
           return iv
       }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test notification"
        return label
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.25
        button.addTarget(self, action: #selector(followTap), for: .touchUpInside)
        return button
    }()
    
    lazy var epkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View EPK", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.25
        button.addTarget(self, action: #selector(epkTap), for: .touchUpInside)
        return button
    }()
       
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.setDimensions(width: 100, height: 32)
        followButton.layer.cornerRadius = 32 / 2
        followButton.anchor(right: rightAnchor, paddingRight: 12)
        followButton.addTarget(self, action: #selector(followTap), for: .touchUpInside)
        
        contentView.addSubview(epkButton)
        epkButton.centerY(inView: self)
        epkButton.setDimensions(width: 100, height: 32)
        epkButton.layer.cornerRadius = 32 / 2
        epkButton.anchor(right: rightAnchor, paddingRight: 12)
        epkButton.addTarget(self, action: #selector(epkTap), for: .touchUpInside)



        
        let stack = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])
        stack.spacing = 8
        stack.alignment = .center
        
        contentView.addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        if followButton.isHidden == false || epkButton.isHidden == false {
            stack.anchor(right: self.followButton.leftAnchor, paddingRight: 8)
        } else if followButton.isHidden == true || epkButton.isHidden == true {
            stack.anchor(right: rightAnchor, paddingRight: 12)

        }
        
     
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc func followTap() {
        delegate?.followTap(self)
    }
    
    @objc func epkTap() {
        delegate?.epkTap(self)
    }
    
    
    func configure() {
        guard let notification = notification else { return }
        let viewModel = NotificationViewModel(notification: notification)
        guard let url = URL(string: viewModel.profileImageURl!) else { return }
        profileImageView.kf.setImage(with: url)
        notificationLabel.attributedText = viewModel.notificationText
        
        followButton.isHidden = viewModel.shouldHideFollowButton
        epkButton.isHidden = viewModel.shouldHideEPKButton
//        followButton.setTitle(viewModel.followButtonText, for: .normal)
    }
    
    func checkUserIsFollowed() {
        guard let user = notification?.user else { return }
        Service.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            user.isFollowed = isFollowed
            if user.isCurrentUser == true {
                self.followButton.setTitle("Edit Profile", for: .normal)
                self.followButton.setTitleColor(UIColor(named: "BlackColor"), for: .normal)
                self.followButton.backgroundColor = .clear
                self.followButton.layer.borderColor = UIColor(named: "BlackColor")?.cgColor
     
            }
             else if isFollowed == true {
                self.followButton.setTitle("Following", for: .normal)
                self.followButton.setTitleColor(.white, for: .normal)
                self.followButton.backgroundColor = UIColor(named: "FollowColor")
                self.followButton.layer.borderColor = UIColor.clear.cgColor
       
            } else if isFollowed == false {
                self.followButton.setTitle("Follow", for: .normal)
                self.followButton.setTitleColor(UIColor(named: "BlackColor"), for: .normal)
                self.followButton.backgroundColor = .clear
                self.followButton.layer.borderColor = UIColor(named: "BlackColor")?.cgColor
              
            }
        }
    }
}
