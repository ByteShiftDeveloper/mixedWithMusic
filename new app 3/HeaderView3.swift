//
//  HeaderView3.swift
//  new app 3
//
//  Created by William Hinson on 3/4/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit
import Kingfisher

class HeaderView3: UIViewController {
    
    @IBOutlet weak var coverImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var covermageView: UIImageView!
    @IBOutlet weak var titleView: UIScrollView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var btnMessage: UIButton!
    
    
    @IBOutlet weak var btnFollow: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
   
    var animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: nil)

    var titleInitialCenterY: CGFloat!
    var covernitialCenterY: CGFloat!
    var covernitialHeight: CGFloat!
    var stickyCover = true
    
    var viewDidLayoutOnce = false
    
    var user: User?
    
    var gigs: Gigs?
//    {
//
//        didSet {
//            configure()
//        }
//    }
    
    var profileVC : ApplyToGigController?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        animator.addAnimations {
            self.visualEffectView.effect = UIBlurEffect(style: .regular)
        }
        
        covermageView.layer.zPosition = 0.1
        visualEffectView.layer.zPosition = covermageView.layer.zPosition + 0.1
        titleView.layer.zPosition = visualEffectView.layer.zPosition + 0.1
        userImageView.layer.zPosition = titleView.layer.zPosition

        visualEffectView.effect = nil

        userImageView.rounded()
        userImageView.bordered(lineWidth: 8)
        
//
//        setBtnStyle(button: btnFollow)
//        setBtnStyle(button: btnMessage)
        
//        btnMessage.addTarget(self, action: #selector(messagedTapped), for: .touchUpInside)
//        btnFollow.addTarget(self, action: #selector(followBtn), for: .touchUpInside)
//
//        let followTap = UITapGestureRecognizer(target: self, action: #selector(followersTapped(_:)))
//        followersLabel.isUserInteractionEnabled = true
//        followersLabel.addGestureRecognizer(followTap)
//
//        let followingTap = UITapGestureRecognizer(target: self, action: #selector(folliwngTapped))
//        followingLabel.isUserInteractionEnabled = true
//        followingLabel.addGestureRecognizer(followingTap)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(handleHeaderImageZoom(tapGesture:)))
        imageTap.numberOfTouchesRequired = 1
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(imageTap)

        let headerImageTap = UITapGestureRecognizer(target: self, action: #selector(handleHeaderImageZoom(tapGesture:)))
        headerImageTap.numberOfTouchesRequired = 1
        covermageView.isUserInteractionEnabled = true
        covermageView.addGestureRecognizer(headerImageTap)
        
        
//        btnMessage.isHidden = true
        followersLabel.isHidden = false
        bioLabel.isHidden = true
        
        configure()
        
    }
    
    @objc func handleImageZoom(tapGesture: UITapGestureRecognizer) {
//        delegate?.handleImageZoom(self)
        let imageView = tapGesture.view as? UIImageView
        self.profileVC?.performZoomInForStartingImageView(startingImageView: imageView!)
    }
    
    @objc func handleHeaderImageZoom(tapGesture: UITapGestureRecognizer) {
//        delegate?.handleHeaderImageZoom(self)
        let imageView = tapGesture.view as? UIImageView
        self.profileVC?.performZoomInForStartingImageView(startingImageView: imageView!)
    }
    
    func setBtnStyle (button : UIButton){
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setDimensions(width: 100, height: 36)
    }
    func configure() {
        guard let user = user else { return }
        
        print("Current user is \(user.uid)")
        let viewModel = ProfileHeaderViewModel(user: user)
////        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
//        followingLabel.attributedText = viewModel.followingString
//        followersLabel.attributedText = viewModel.followersString
        
        let fullName = user.fullname
        userNameLabel.text = fullName
        lblTitle.text = fullName

        let profileImageUrl = URL(string: user.profileImageURL)
        userImageView.kf.setImage(with: profileImageUrl)
        
        
        if user.headerImageURL == nil {
            let headerImageUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/mixed-with-music-28704.appspot.com/o/users%2Fprofile%2FStandard%20Header%2FDeep%20Space.jpg?alt=media&token=ccf92ddb-604a-45a2-9e6c-8d21029c726f")
            covermageView.kf.setImage(with: headerImageUrl)

        } else if user.headerImageURL != nil {
            let headerImageUrl = URL(string: user.headerImageURL)
            covermageView.kf.setImage(with: headerImageUrl)

        }
//

//
        guard let applications = gigs?.applications else { return }
        if applications == 1 {
            followersLabel.text = "\(applications) applicant"
        } else {
            followersLabel.text = "\(applications) applicants"
        }
        
        userName.text = gigs?.location
        
        
//
//        if user.isCurrentUser {
//            messageButton.isHidden = true
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        animator.fractionComplete = 0.25
        animator.stopAnimation(true)
        animator.finishAnimation(at: .current)

    }
    
    override func viewDidAppear(_ animated: Bool) {
            animator.addAnimations {
                self.visualEffectView.effect = UIBlurEffect(style: .regular)
            }
            
            
            covermageView.layer.zPosition = 0.1
            visualEffectView.layer.zPosition = covermageView.layer.zPosition + 0.1
            titleView.layer.zPosition = visualEffectView.layer.zPosition + 0.1
            userImageView.layer.zPosition = titleView.layer.zPosition

            visualEffectView.effect = nil
        }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        titleView.setContentOffset(CGPoint(x: 0, y: -titleView.frame.height), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !viewDidLayoutOnce{
            viewDidLayoutOnce = true
            covernitialCenterY = covermageView.center.y
            covernitialHeight = covermageView.frame.height
            titleInitialCenterY = titleView.center.y
        }

    }
    
    
    
    func handleHeaderImageZoom(_ header: ProfileViewHeader) {
        print("Image is being tapped")
    }
    
    func handleImageZoom(_ header: ProfileViewHeader) {
        print("Image is being tapped")
    }
    
    
    @objc func folliwngTapped(_ header: ProfileViewHeader) {
        print("Following Tapped")
        let controller = Following()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func followersTapped(_ header: ProfileViewHeader) {
        print("Followers Tapped")
        let controller = Followers()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func editProfileTapped(){
//        let controller = EditProfileTableViewController(user: user!)
//        let nav = UINavigationController(rootViewController: controller)
//        nav.modalPresentationStyle = .fullScreen
//        present(nav, animated: true, completion: nil)
        let controller = SettingsTableViewController(user: user!)
        navigationController?.pushViewController(controller, animated: true)
        return
    }
    
    @objc func followBtn(){
        self.btnFollow.backgroundColor = .white
        self.btnFollow.setTitleColor(.black, for: .normal)
        self.btnFollow.layer.borderColor = UIColor.black.cgColor
        self.btnFollow.setTitle("Apply", for: .normal)
    }
    
    @objc func messagedTapped(){
        print("tapped")
        guard let user = user else { return }
        self.showChatController(forUser: user)
    }

    func showChatController(forUser user: User) {
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        navigationController?.pushViewController(chatController, animated: true)
    }
    
//    @IBAction func readMoreAction(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.3) {
//            self.descriptionLabel.numberOfLines = 0
//            self.gradientView.isHidden = true
//        }
//    }
    
    func update(with progress: CGFloat, minHeaderHeight: CGFloat){

        let y = progress * (view.frame.height - minHeaderHeight)
        
        coverImageHeightConstraint.constant = max(covernitialHeight, covernitialHeight - y)
                
        let titleOffset = max(min(0, (userNameLabel.convert(userNameLabel.bounds, to: nil).minY - minHeaderHeight)), -titleView.frame.height)
        titleView.contentOffset.y = -titleOffset-titleView.frame.height
        
        if progress < 0 {
            animator.fractionComplete = abs(min(0, progress))
        }else{
            animator.fractionComplete = (abs((titleOffset)/(titleView.frame.height)))
        }
        
        let topLimit = covernitialHeight - minHeaderHeight
        if y > topLimit{
            covermageView.center.y = covernitialCenterY + y - topLimit
            if stickyCover{
                self.stickyCover = false
                userImageView.layer.zPosition = 0
            }
        }else{
            covermageView.center.y = covernitialCenterY
            let scale = min(1, (1-progress*1.3))
            let t = CGAffineTransform(scaleX: scale, y: scale)
            userImageView.transform = t.translatedBy(x: 0, y: userImageView.frame.height*(1 - scale))
            
            if !stickyCover{
                self.stickyCover = true
                userImageView.layer.zPosition = titleView.layer.zPosition
            }
        }
        visualEffectView.center.y = covermageView.center.y
        titleView.center.y = covermageView.frame.maxY - titleView.frame.height/2
    }
    
}

