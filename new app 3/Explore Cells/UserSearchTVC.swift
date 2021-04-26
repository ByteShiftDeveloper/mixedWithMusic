//
//  UserSearchTVC.swift
//  new app 3
//
//  Created by William Hinson on 8/12/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol UserSearchDelegate: class {
    func handleProfileImageTapped(_ cell:UserSearchTVC)
    func didTapFollow(_ cell: UserSearchTVC)
}

class UserSearchTVC: UITableViewCell {
    
    var user: User? {
        didSet {
            configure()
            checkUserIsFollowed()
        }
    }
    
    weak var delegate: UserSearchDelegate?
    
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
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Test notification"
        label.textColor = UIColor(named: "BlackColor")
        return label
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.25
        button.addTarget(self, action: #selector(handleFollowTap), for: .touchUpInside)
        return button
    }()
    
    private let ADMPLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Producer"
        return label
    }()
    
    private let verifiedMark: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark.seal.fill")
        iv.setDimensions(width: 18, height: 16)
        iv.tintColor = UIColor(named: "BlackColor")
        return iv
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = " "
        return label
    }()

       
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        let stack2 = UIStackView(arrangedSubviews: [notificationLabel, verifiedMark, ADMPLabel])
        stack2.spacing = 8
        stack2.distribution = .equalSpacing
        self.contentView.addSubview(stack2)
        stack2.anchor(top: self.topAnchor, paddingTop: 8)
        
        let labelStack = UIStackView(arrangedSubviews: [stack2, timestampLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -8
        
        addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.setDimensions(width: 100, height: 32)
        followButton.layer.cornerRadius = 32 / 2
        followButton.anchor(right: rightAnchor, paddingRight: 12)
        followButton.addTarget(self, action: #selector(handleFollowTap), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        stack.spacing = 8
//        stack.alignment = .center
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
//        stack.anchor(right: rightAnchor, paddingRight: 12)
        

        
    
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
        guard let user = user else { return }
        
        let viewModel = ExploreViewModel(user: user)
//        followButton.setTitle(viewModel.actionButtonTitle, for: .normal)
//        followButton.backgroundColor = viewModel.actionButtonColor
//        followButton.setTitleColor(viewModel.actionButtonTitleColor, for: .normal)
//        followButton.layer.borderColor = viewModel.actionButtonBorderColor.cgColor
        
        profileImageView.loadImage(with: user.profileImageURL)
        
        notificationLabel.text = user.fullname
        
        if user.artistBand != "" {
            ADMPLabel.text = user.artistBand
        }
        
        if user.isVerified != "" {
            verifiedMark.isHidden = false
        }
        if user.isVerified == "" {
            verifiedMark.isHidden = true
        }
        
//        if user.city != "" && user.state != "" {
//            timestampLabel.text = user.city + ", " + user.state
//        }
    }
    
    func checkUserIsFollowed() {
        guard let user = user else { return }
        Service.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user?.isFollowed = isFollowed
            if self.user?.isCurrentUser == true {
                self.followButton.setTitle("Edit Profile", for: .normal)
                self.followButton.setTitleColor(UIColor(named: "BlackColor"), for: .normal)
                self.followButton.backgroundColor = .clear
                self.followButton.layer.borderColor = UIColor(named: "BlackColor")?.cgColor
            }
             else if isFollowed == true {
                self.followButton.setTitle("Following", for: .normal)
                self.followButton.setTitleColor(UIColor(named: "DefaultBackgroundColor"), for: .normal)
                self.followButton.backgroundColor = UIColor(named: "BlackColor")
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
