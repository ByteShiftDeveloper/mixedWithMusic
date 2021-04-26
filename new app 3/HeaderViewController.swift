//
//  HeaderViewController.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

class HeaderViewController: UIViewController {
    
//    @IBOutlet weak var coverImageHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var userImageView: UIImageView!
//    @IBOutlet weak var userNameLabel: UILabel!
//    @IBOutlet weak var descriptionLabel: UILabel!
//    @IBOutlet weak var covermageView: UIImageView!
//    @IBOutlet weak var titleView: UIScrollView!
//    @IBOutlet weak var visualEffectView: UIVisualEffectView!
//    @IBOutlet weak var gradientView: UIView!
//
//    var animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: nil)
//
//    var titleInitialCenterY: CGFloat!
//    var covernitialCenterY: CGFloat!
//    var covernitialHeight: CGFloat!
//    var stickyCover = true
//
//    var viewDidLayoutOnce = false
    
    var user: User? {
        
        didSet {
            configure()
        }
    }
    
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
//        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
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
//        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    lazy var messageButton: UIButton = {
       let button = UIButton()
        button.setTitle("Message", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        button.addTarget(self, action: #selector(handleMessageTap), for: .touchUpInside)
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
        
//        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
//        label.addGestureRecognizer(followTap)
        label.text = "3 Following"
        return label
    }()
    
    private let followersLabel: UILabel = {
       let label = UILabel()
        
//        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
//        label.isUserInteractionEnabled = true
//        label.addGestureRecognizer(followTap)
        label.text = "12,345 Followers"
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 200)
         
        view.addSubview(profileImageView)
         profileImageView.anchor(top: containerView.bottomAnchor, paddingTop: -50, paddingLeft: 8)
         profileImageView.centerX(inView: containerView)
         profileImageView.setDimensions(width: 100, height: 100)
         profileImageView.layer.cornerRadius = 100 / 2
         
        view.addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 12)
         editProfileFollowButton.setDimensions(width: 100, height: 36)
         editProfileFollowButton.layer.cornerRadius = 36 / 2
         
        view.addSubview(messageButton)
        messageButton.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 12)
         messageButton.setDimensions(width: 100, height: 36)
         messageButton.layer.cornerRadius = 36 / 2
         
         
         
         
         let userDetailStack = UIStackView(arrangedSubviews: [fullnameLabel, whatDoYouConsiderYourselfLabel, bioLabel])
         userDetailStack.axis = .vertical
         userDetailStack.distribution = .fillProportionally
         userDetailStack.spacing = 4
         
        view.addSubview(userDetailStack)
        userDetailStack.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8)
        userDetailStack.centerX(inView: self.view)
         
         let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
         followStack.axis = .horizontal
         followStack.spacing = 8
         followStack.distribution = .fillEqually
         
        view.addSubview(followStack)
         followStack.anchor(top: userDetailStack.bottomAnchor, paddingTop: 8)
        followStack.centerX(inView: self.view)
         
//        view.addSubview(filterBar)
//         filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        
        
//        animator.addAnimations {
//            self.visualEffectView.effect = UIBlurEffect(style: .regular)
//        }
//
//        covermageView.layer.zPosition = 0.1
//        visualEffectView.layer.zPosition = covermageView.layer.zPosition + 0.1
//        titleView.layer.zPosition = visualEffectView.layer.zPosition + 0.1
//        userImageView.layer.zPosition = titleView.layer.zPosition
//
//        visualEffectView.effect = nil
//
////        userImageView.rounded()
////        userImageView.bordered(lineWidth: 8)
//
//        descriptionLabel.numberOfLines = 2
        
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
    
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        titleView.setContentOffset(CGPoint(x: 0, y: -titleView.frame.height), animated: true)
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        if !viewDidLayoutOnce{
//            viewDidLayoutOnce = true
//            covernitialCenterY = covermageView.center.y
//            covernitialHeight = covermageView.frame.height
//            titleInitialCenterY = titleView.center.y
//        }
//
//    }
//
//    @IBAction func readMoreAction(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.3) {
//            self.descriptionLabel.numberOfLines = 0
//            self.gradientView.isHidden = true
//        }
//    }
//
//    func update(with progress: CGFloat, minHeaderHeight: CGFloat){
//
//        let y = progress * (view.frame.height - minHeaderHeight)
//
//        coverImageHeightConstraint.constant = max(covernitialHeight, covernitialHeight - y)
//
//        let titleOffset = max(min(0, (userNameLabel.convert(userNameLabel.bounds, to: nil).minY - minHeaderHeight)), -titleView.frame.height)
//        titleView.contentOffset.y = -titleOffset-titleView.frame.height
//
//        if progress < 0 {
//            animator.fractionComplete = abs(min(0, progress))
//        }else{
//            animator.fractionComplete = (abs((titleOffset)/(titleView.frame.height)))
//        }
//
//        let topLimit = covernitialHeight - minHeaderHeight
//        if y > topLimit{
//            covermageView.center.y = covernitialCenterY + y - topLimit
//            if stickyCover{
//                self.stickyCover = false
//                userImageView.layer.zPosition = 0
//            }
//        }else{
//            covermageView.center.y = covernitialCenterY
//            let scale = min(1, (1-progress*1.3))
//            let t = CGAffineTransform(scaleX: scale, y: scale)
//            userImageView.transform = t.translatedBy(x: 0, y: userImageView.frame.height*(1 - scale))
//
//            if !stickyCover{
//                self.stickyCover = true
//                userImageView.layer.zPosition = titleView.layer.zPosition
//            }
//        }
//        visualEffectView.center.y = covermageView.center.y
//        titleView.center.y = covermageView.frame.maxY - titleView.frame.height/2
//    }
//
//
    
}
