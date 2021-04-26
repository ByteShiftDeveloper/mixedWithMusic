//
//  ProfileViewHeader.swift
//  new app 3
//
//  Created by William Hinson on 5/7/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Foundation
import Firebase

protocol ProfileViewHeaderDelegate: class {
    func handleDismiss(_ header: ProfileViewHeader)
    func editProfileFollowButton(_ header: ProfileViewHeader)
    func didSelect(filter: ProfileFilterOptions)
    func folliwngTapped(_ header: ProfileViewHeader)
    func followersTapped(_ header: ProfileViewHeader)
    func handleImageZoom(_ header: ProfileViewHeader)
    func handleHeaderImageZoom(_ header: ProfileViewHeader)
    func handleMessageTap(_ header: ProfileViewHeader)
}


class ProfileViewHeader: UICollectionReusableView {
  

    weak var delegate: ProfileViewHeaderDelegate?
    var profileController: ProfileCollectionViewController?
    
    var user: User? {
        
        didSet {
            configure()
        }
    }
    
    
    let filterBar = ProfileFilterView()
        
    private lazy var containerView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.addSubview(backButton)
//        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
//        backButton.setDimensions(width: 30, height: 30)
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
        
    }()
    
    lazy var editProfileFollowButton: UIButton = {
       let button = UIButton()
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    lazy var messageButton: UIButton = {
       let button = UIButton()
        button.setTitle("Message", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleMessageTap), for: .touchUpInside)
        return button
    }()
    
    private let fullnameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let whatDoYouConsiderYourselfLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
//        label.text = "Artist"
        label.textAlignment = .center
        return label
    }()
    
    
    
    private let bioLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 3
//        label.text = "This is a test to see how the user's bio label looks, hopefully this works out"
        return label
    }()
    
 
    
    private let followingLabel: UILabel = {
       let label = UILabel()
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        label.text = "3 Following"
        return label
    }()
    
    private let followersLabel: UILabel = {
       let label = UILabel()
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        label.text = "12,345 Followers"
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        filterBar.delegate = self
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(handleImageZoom))
        imageTap.numberOfTouchesRequired = 1
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        
        let headerImageTap = UITapGestureRecognizer(target: self, action: #selector(handleHeaderImageZoom))
        headerImageTap.numberOfTouchesRequired = 1
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(headerImageTap)
        
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        followingLabel.isUserInteractionEnabled = true
        followingLabel.addGestureRecognizer(followingTap)
        
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        followersLabel.isUserInteractionEnabled = true
        followersLabel.addGestureRecognizer(followersTap)
        
       addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 200)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, paddingTop: -50, paddingLeft: 8)
        profileImageView.centerX(inView: containerView)
        profileImageView.setDimensions(width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100 / 2
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 12)
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        editProfileFollowButton.layer.cornerRadius = 36 / 2
        
        addSubview(messageButton)
        messageButton.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        messageButton.setDimensions(width: 100, height: 36)
        messageButton.layer.cornerRadius = 36 / 2
        
        
        
        
        let userDetailStack = UIStackView(arrangedSubviews: [fullnameLabel, whatDoYouConsiderYourselfLabel, bioLabel])
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 4
        
        addSubview(userDetailStack)
        userDetailStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8)
        userDetailStack.centerX(inView: self)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        
        addSubview(followStack)
        followStack.anchor(top: userDetailStack.bottomAnchor, paddingTop: 8)
        followStack.centerX(inView: self)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        
      
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let user = user else { return }
        
        print("Current user is \(user.uid)")
        
        let viewModel = ProfileHeaderViewModel(user: user)
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        
        let fullName = user.fullname
        fullnameLabel.text = fullName
        
        guard let profileImageUrl = user.profileImageURL else { return }
        profileImageView.loadImage(with: profileImageUrl)
        
        guard let headerImageUrl = user.headerImageURL else { return }
        containerView.loadImage(with: headerImageUrl)
        
        let bio = user.bio
        bioLabel.text = bio
        
        whatDoYouConsiderYourselfLabel.text = user.username
        
        
        if user.isCurrentUser {
            messageButton.isHidden = true
        }
    }
    
//    func fetchUser() {
//        UserService.shared.fetchNewUser(uid: <#T##String#>, completion: <#T##(User) -> Void#>)
//    }
    
    @objc func handleEditProfileFollow() {
        delegate?.editProfileFollowButton(self)
        
    }
    
    
    @objc func handleDismiss() {
        delegate?.handleDismiss(self)
    }
    
    @objc func handleFollowersTapped() {
        delegate?.followersTapped(self)
        print("tapped")

    }
    
    @objc func handleFollowingTapped() {
        delegate?.folliwngTapped(self)
        print("tapped")
    }
    
    @objc func handleImageZoom(tapGesture: UITapGestureRecognizer) {
        delegate?.handleImageZoom(self)
        let imageView = tapGesture.view as? UIImageView
        self.profileController?.performZoomInForStartingImageView(startingImageView: imageView!)
    }
    
    @objc func handleHeaderImageZoom(tapGesture: UITapGestureRecognizer) {
        delegate?.handleHeaderImageZoom(self)
        let imageView = tapGesture.view as? UIImageView
        self.profileController?.performZoomInForStartingImageView(startingImageView: imageView!)
    }
    
    @objc func handleMessageTap() {
        delegate?.handleMessageTap(self)
    }

    

}

extension ProfileViewHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect index: Int) {
        guard let filter = ProfileFilterOptions(rawValue: index) else { return }
        
        delegate?.didSelect(filter: filter)
    }
}
