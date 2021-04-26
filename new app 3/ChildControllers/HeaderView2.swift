//
//  HeaderViewController.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit

class HeaderView2: UIViewController {
    
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
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnFollow: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
   
    var animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: nil)

    var titleInitialCenterY: CGFloat!
    var covernitialCenterY: CGFloat!
    var covernitialHeight: CGFloat!
    var stickyCover = true
    
    var viewDidLayoutOnce = false
    
    var user: User?
//    {
//
//        didSet {
//            configure()
//        }
//    }
    
    var profileVC : NewProfileVC?

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
        
        setBtnStyle(button: btnEdit)
        setBtnStyle(button: btnFollow)
        setBtnStyle(button: btnMessage)
        
        btnEdit.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        btnMessage.addTarget(self, action: #selector(messagedTapped), for: .touchUpInside)
        btnFollow.addTarget(self, action: #selector(followBtn), for: .touchUpInside)

        let followTap = UITapGestureRecognizer(target: self, action: #selector(followersTapped(_:)))
        followersLabel.isUserInteractionEnabled = true
        followersLabel.addGestureRecognizer(followTap)
        
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(folliwngTapped))
        followingLabel.isUserInteractionEnabled = true
        followingLabel.addGestureRecognizer(followingTap)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(handleHeaderImageZoom(tapGesture:)))
        imageTap.numberOfTouchesRequired = 1
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(imageTap)

        let headerImageTap = UITapGestureRecognizer(target: self, action: #selector(handleHeaderImageZoom(tapGesture:)))
        headerImageTap.numberOfTouchesRequired = 1
        covermageView.isUserInteractionEnabled = true
        covermageView.addGestureRecognizer(headerImageTap)
        
        
        if ((user?.isCurrentUser) != nil) {
            btnMessage.isHidden = true
            btnFollow.isHidden = true
            btnEdit.isHidden = false

        }else{
            btnMessage.isHidden = false
            btnFollow.isHidden = false
            btnEdit.isHidden = true
        }
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
    }
    func configure() {
        guard let user = user else { return }
        
        print("Current user is \(user.uid)")
        let viewModel = ProfileHeaderViewModel(user: user)
//        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        
        let fullName = user.fullname
        userNameLabel.text = fullName
        lblTitle.text = fullName

        guard let profileImageUrl = user.profileImageURL else { return }
        userImageView.loadImage(with: profileImageUrl)
        
        guard let headerImageUrl = user.headerImageURL else { return }
        covermageView.loadImage(with: headerImageUrl)
        
        let bio = user.bio
        bioLabel.text = bio
//
        userName.text = user.username
        
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
        let controller = EditProfileTableViewController(user: user!)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        return
    }
    
    @objc func followBtn(){
        if user!.isFollowed {
            Service.shared.unfollowUser(uid: user!.uid) { (err, ref) in
                self.user?.isFollowed = false
                self.btnFollow.setTitle("Follow", for: .normal)
            }
        } else {
            Service.shared.followUser(uid: (user!.uid)) { (ref, err) in
                self.user?.isFollowed = true
                self.btnFollow.setTitle("Following", for: .normal)

                NotificationService.shared.uploadNotification(type: .follow, user: self.user)
            }
        }
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


extension UIView{
    func bordered(lineWidth: CGFloat, strokeColor: UIColor = .systemBackground){
        let path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: self.frame.width/2)
        let borderLayer = CAShapeLayer()
        borderLayer.lineWidth = lineWidth
        borderLayer.strokeColor = strokeColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = self.bounds
        borderLayer.path = path.cgPath
        self.layer.addSublayer(borderLayer)
    }
    
    func rounded(insets: UIEdgeInsets = .zero){
        let path = UIBezierPath.init(roundedRect: self.bounds.inset(by: insets), cornerRadius: self.frame.width/2)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}

extension UIColor{
    static let background: UIColor  = {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return UIColor.white
        }
    }()
}
