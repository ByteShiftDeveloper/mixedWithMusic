//
//  FeedController.swift
//  new app 3
//
//  Created by William Hinson on 5/15/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//


import UIKit
import Firebase
import FirebaseMessaging
import AVFoundation
import AVKit
import SkeletonView
import Kingfisher

private let feedCollectionViewCell = "PostCell"

protocol FeedControllerDelegate: class {
    func handleMenuToggle()
}

class FeedController: UICollectionViewController {
    
    weak var delegate: FeedControllerDelegate?
    var song: SongPost?
    var miniPlayerInView = false
    var playerController : PlayerDetailController?
    
    var chatController : ChatController?
    
    let keyWindow = UIApplication.shared.connectedScenes
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows.first
    
    var statusBarUIView: UIView? {
      if #available(iOS 13.0, *) {
          let tag = 3848245
          let keyWindow = UIApplication.shared.connectedScenes
              .map({$0 as? UIWindowScene})
              .compactMap({$0})
              .first?.windows.first
          if let statusBar = keyWindow?.viewWithTag(tag) {
              return statusBar
          } else {
              let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
              let statusBarView = UIView(frame: height)
              statusBarView.tag = tag
              statusBarView.layer.zPosition = 999999
              keyWindow?.addSubview(statusBarView)
              return statusBarView
          }
      } else {

          if responds(to: Selector(("statusBar"))) {
              return value(forKey: "statusBar") as? UIView
          }
      }
      return nil
    }

    
    var user: User? {
          didSet { congfigureUI()
            collectionView.reloadData()
        }
      }

      private var posts = [Post]() {
          didSet { collectionView.reloadData() }
      }
    
    private var actionSheetLauncher: ActionSheetLauncher!
    private var shareSheetLauncher: ShareSheetLaunch!
    
    var seeNewPostsButton: SeeNewPostsButton!
    var SNPBTopAnchor: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor(named: "BlackColor")
   
        
        collectionView.backgroundColor = UIColor(named: "DefaultBackgroundColor")
        
        congfigureUI()
        fetchPosts()
        setUserFCMToken()
        checkIfUserLikedTweets()

        self.tabBarController?.tabBar.items![3].badgeValue = "1"
     
//        let layoutGuide = self.view.safeAreaLayoutGuide

     
        
        collectionView.register(UpdatedPostCollectionCell.self, forCellWithReuseIdentifier: "PostCell")
        collectionView.reloadData()
        
//        seeNewPostsButton = SeeNewPostsButton()
//        view.addSubview(seeNewPostsButton)
//        seeNewPostsButton.translatesAutoresizingMaskIntoConstraints = false
//        seeNewPostsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        SNPBTopAnchor = seeNewPostsButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 12)
//        SNPBTopAnchor.isActive = true
//        seeNewPostsButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
//        seeNewPostsButton.widthAnchor.constraint(equalToConstant: seeNewPostsButton.button.bounds.width).isActive = true
//        seeNewPostsButton.button.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.setBackgroundImage(.none, for: .default)
//        self.navigationController?.navigationBar.shadowImage = .none
        navigationController?.navigationBar.backgroundColor = UIColor(named: "DefaultBackgroundColor")
//        statusBarUIView?.backgroundColor = .white
        messageBadgeValue()
        checkIfUserLikedTweets()
        
    }
    
    
//    func toggleSNPB(hidden:Bool) {
//        if hidden {
//            UIView.animate(withDuration: 0.5, delay: 00, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut) {
//                self.SNPBTopAnchor.constant = -44.0
//                self.view.layoutIfNeeded()
//            } completion: { (nil) in
//            }
//
//        } else {
//
//        }
//    }
    
    
    fileprivate func showActionSheet(forUser user: User, forPost post: Post) {
        actionSheetLauncher = ActionSheetLauncher(user: user, post: post)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
    
    fileprivate func showShareSheet(forUser user: User, forPost post: Post) {
        shareSheetLauncher = ShareSheetLaunch(user: user, post: post)
        shareSheetLauncher.show()
    }
    
    @objc func handleRefresh() {
//        toggleSNPB(hidden: true)
        fetchPosts()
        
    }

    
    func fetchPosts() {
        
        collectionView.refreshControl?.beginRefreshing()
        
//        Service.shared.FetchPosts { posts in
//            self.posts = posts.sorted(by: { $0.createdAt > $1.createdAt })
//            self.checkIfUserLikedTweets()
//            self.collectionView.refreshControl?.endRefreshing()
//        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
                Service.shared.fetchPostsNew { (posts) in
                    self.posts = posts.sorted(by: { $0.createdAt > $1.createdAt})
                    self.checkIfUserLikedPost(self.posts)
                    self.collectionView.refreshControl?.endRefreshing()
//                    self.collectionView.reloadData()
                }
        }
    }
    
    func checkIfUserLikedPost(_ posts: [Post]) {
        posts.forEach { post in
            Service.shared.checkIfUserLikedPost(post) { didLike in
            guard didLike == true else { return }
                
                if let index = posts.firstIndex(where: { $0.postID == post.postID}) {
                    self.posts[index].didLike = true
                    
                    self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])// D
                }
            }
        }
    }
    
    func checkIfUserLikedTweets() {
        self.posts.forEach { post in
            Service.shared.checkIfUserLikedPost(post) { didLike in
                guard didLike == true else { return }
                
                if let index = self.posts.firstIndex(where: { $0.postID == post.postID }) {
                    self.posts[index].didLike = true
                }
            }
        }
    }
    
    let badgeSize: CGFloat = 20
    let badgeTag = 9830384

    func badgeLabel(withCount count: Int) -> UILabel {
        let badgeCount = UILabel(frame: CGRect(x: 0, y: 0, width: badgeSize, height: badgeSize))
        badgeCount.translatesAutoresizingMaskIntoConstraints = false
        badgeCount.tag = badgeTag
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.backgroundColor = .systemRed
        badgeCount.text = String(count)
        return badgeCount
    }
    
    let messagButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = UIColor(named: "BlackColor")
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
//        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return button
    }()
       
    func congfigureUI() {

           guard let user = user else { return }
           let profileImageView = UIImageView()
           profileImageView.backgroundColor = .lightGray
           profileImageView.contentMode = .scaleAspectFill
           profileImageView.setDimensions(width: 40, height: 40)
           profileImageView.layer.cornerRadius = 40 / 2
           profileImageView.layer.masksToBounds = true
           profileImageView.layer.borderWidth = 2
           profileImageView.layer.borderColor = UIColor(named: "BlackColor")?.cgColor
           profileImageView.isUserInteractionEnabled = true
           let url = URL(string: user.profileImageURL)
           profileImageView.kf.setImage(with: url)
           let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
           profileImageView.addGestureRecognizer(tap)
           navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
           navigationItem.rightBarButtonItem = UIBarButtonItem(customView: messagButton)
           messagButton.setDimensions(width: 25, height: 25)
           messagButton.addTarget(self, action: #selector(handleMessageTap), for: .touchUpInside)
//            messagButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//           navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "paperplane"), style: .plain, target: self, action: #selector(handleMessageTap))
           let refreshControl = UIRefreshControl()
           refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
           collectionView.refreshControl = refreshControl
       }
    
    func showBadge(withCount count: Int) {
        let badge = badgeLabel(withCount: count)
        messagButton.addSubview(badge)

        NSLayoutConstraint.activate([
            badge.leftAnchor.constraint(equalTo: messagButton.leftAnchor, constant: 14),
            badge.topAnchor.constraint(equalTo: messagButton.topAnchor, constant: -8),
            badge.widthAnchor.constraint(equalToConstant: badgeSize),
            badge.heightAnchor.constraint(equalToConstant: badgeSize)
        ])
    }
    
    func removeBadge() {
        if let badge = messagButton.viewWithTag(badgeTag) {
            badge.removeFromSuperview()
        }
    }
    
    func messageBadgeValue() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//        UNREAD_MESSAGES_REF.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
//            guard let count = dictionary["unread"] as? Int else { return }
//            print("The total amount of unread messages is \(count)")
//            if count >= 1 {
//                self.showBadge(withCount: count)
//            } else if count == 0 {
//                self.removeBadge()
//            }
//        }
         if unreadCount >= 1 {
             self.showBadge(withCount: unreadCount)
         } else if unreadCount == 0 {
             self.removeBadge()
         }
    }
    
    func fetchMessage(withMessageId messageId: String) {
        
        MESSAGES_REF.child(messageId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let message = Message(dictionary: dictionary)
            let read = message.read
        
    }
}

    
    @objc func handleMessageTap() {
        let messagesController = MessagesTableViewController()
//        self.messageNotificationView.isHidden = true
        navigationController?.pushViewController(messagesController, animated: true)
    }
    
    func handleHashTagTapped(forCell cell: UpdatedPostCollectionCell) {
          cell.postTextLabel.handleHashtagTap { hashtag in
              print("Hashtag is \(hashtag)")
            let controller = HashtagsController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.hashtag = hashtag
            self.navigationController?.pushViewController(controller, animated: true)
          }
      }
    
    @objc func handleProfileImageTap() {
//           delegate?.handleMenuToggle()
       guard let user = user else { return }
//        let controller = ProfileCollectionViewController(user: user)
        let controller = NewProfileVC()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
       }
    
       
     override func viewWillAppear(_ animated: Bool) {
            guard let navBar = self.navigationController?.navigationBar else { return }
            guard let tabBar = self.tabBarController?.tabBar else { return }
            
            navBar.tintColor = UIColor(named: "BlackColor")
            tabBar.tintColor = UIColor(named: "BlackColor")
            navBar.backgroundColor = UIColor(named: "DefaultBackgroundColor")
            tabBar.backgroundColor = UIColor(named: "DefaultBackgroundColor")
            navBar.isTranslucent = false
        tabBar.isTranslucent = false
        navBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: false)
//        self.statusBarUIView?.backgroundColor = .white
        
        checkIfUserLikedTweets()

     
        }
    
    func setUserFCMToken() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let fcmToken = Messaging.messaging().fcmToken else { return }
        
        let values = ["fcmToken": fcmToken]
        
        REF_USERS.child(currentUid).updateChildValues(values)
    }
    
    var startingFrame: CGRect?
    var backGroundView: UIView?
    var startingImageView: UIImageView?
        
        func performZoomInForStartingImageView(startingImageView: UIImageView) {
            
            self.startingImageView = startingImageView
            self.startingImageView?.isHidden = true
            startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
            print(startingFrame)
            
            let zoomingImageView = UIImageView(frame: startingFrame!)
            zoomingImageView.backgroundColor = UIColor.red
            zoomingImageView.image = startingImageView.image
            zoomingImageView.isUserInteractionEnabled = true
            zoomingImageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleImageDismiss)))
            
            if let keywindow = keyWindow {
                
                backGroundView = UIView(frame: keywindow.frame)
                backGroundView?.backgroundColor = UIColor.black
                backGroundView?.alpha = 0
                keywindow.addSubview(backGroundView!)
                keyWindow?.addSubview(zoomingImageView)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.backGroundView?.alpha = 1
                    let height = self.startingFrame!.height / self.startingFrame!.width * keywindow.frame.width
                    zoomingImageView.frame = CGRect(x: 0, y: 0, width: keywindow.frame.width, height: height)
                    zoomingImageView.center = keywindow.center
                }, completion: { (Bool) in
    //                zoomOutImageView.removeFromSuperview()
                })
            }
        }
        
       @objc func handleImageDismiss(gesture: UIPanGestureRecognizer) {
        if let zoomOutImageView = gesture.view    {
        if gesture.state == .changed {
            let translation = gesture.translation(in: zoomOutImageView)
            zoomOutImageView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            } else if gesture.state == .ended {
                let translation = gesture.translation(in: zoomOutImageView)
                let velocity = gesture.velocity(in: zoomOutImageView)
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    zoomOutImageView.transform = .identity
                
                    if translation.y > 400 || velocity.y > 200 {
                        zoomOutImageView.removeFromSuperview()
                        self.backGroundView?.alpha = 0
                        self.startingImageView?.isHidden = false
                        }
                    })
                }
            }
        }

    @IBAction func messageButtonPressed(_ sender: Any) {
        
        
        let vc = storyboard?.instantiateViewController(identifier: "MessagesTableViewController") as! MessagesTableViewController
              
              
//              let navigationcontroller = UINavigationController(rootViewController: vc)
//                     navigationcontroller.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)

        
    }
}

extension FeedController {
   
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! UpdatedPostCollectionCell
        
        cell.post = posts[indexPath.row]
        cell.delegate = self
        cell.feedController = self
        handleHashTagTapped(forCell: cell)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = SelectedPostController(post: posts[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)

    }
    
    
}

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 140
              let post = posts[indexPath.row]

              height += textHeight(text: post.text)

        if post.picture != "" && post.postURL == "" && post.video == ""{
            height += 317
        } else if post.picture == "" && post.postURL == "" && post.video != "" {
            height += 317
        }else if post.picture == "" && post.postURL != "" && post.video == "" {
            height += 317
        } else if post.songID != "" {
            height += 100
        } else if post.text == "" {
            height -= 16
        }
              
        return CGSize(width: view.frame.width, height: height)
    }
}


extension FeedController {
    func textHeight(text : String) -> CGFloat{
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: CGFloat.greatestFiniteMagnitude))
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        return label.frame.height
    }
}

extension FeedController: PostDelegate {
    
    func handleSongTap(_ cell: UpdatedPostCollectionCell) {
        let post = cell.post
        
        print("THE BUTTON IS BEING TAPPED")
        Service.shared.fetchUpload(withSongID: post!.songID) { (song) in
            
//
            let y = self.view.frame.height - 64
            let appDelegate = UIApplication.shared.delegate as! AppDelegate

            appDelegate.addPlayerView(song: song)

        }
        
    }
    
    
    func handleActionSheet(_ cell: UpdatedPostCollectionCell) {
        guard let post = cell.post else { return }


        if post.user.isCurrentUser {
            showActionSheet(forUser: post.user, forPost: post)

        } else {
            Service.shared.checkIfUserIsFollowed(uid: post.user.uid) { isFollowed in
                let user = post.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user, forPost: post)
            }

        }
    }
    
    func handlePlayTapped(_ cell: UpdatedPostCollectionCell) {
        guard let post = cell.post else { return }
        guard let videoURL = URL(string: post.video) else { return }
        let launcher = VideoLauncher()
        launcher.videoUrl = videoURL
        print("THIS IS THE VIDEO URL \(videoURL)")
        launcher.showVideoPlayer()

    }

    func handleRepostTapped(_ cell: UpdatedPostCollectionCell) {
        print("Repost clicked")
        guard let post = cell.post else { return }
        let controller = RepostController(user: post.user, post: post)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleImageZoom(_ cell: UpdatedPostCollectionCell) {
        print("Image is being tapped")
    }
    
    func handleShareTap(_ cell: UpdatedPostCollectionCell) {
        guard let post = cell.post else { return }
//        let acticvityVC = UIActivityViewController(activityItems: ["post"], applicationActivities: nil)
//        acticvityVC.popoverPresentationController?.sourceView = self.view
//
//        self.present(acticvityVC, animated: true, completion: nil)
        showShareSheet(forUser: post.user, forPost: post)
        shareSheetLauncher.nav = self
    }
    
    func handleNameTap(_ cell: UpdatedPostCollectionCell) {
        guard let user = cell.post?.user else { return }
//        let controller = ProfileCollectionViewController(user: user)
        let controller = NewProfileVC()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
        print("This was tapped")

    }
    
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUserByUserName(withUsername: username) { user in
//            let controller = ProfileCollectionViewController(user: user)
            let controller = NewProfileVC()
            controller.user = user
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func handleLikeTap(_ cell: UpdatedPostCollectionCell) {
        guard let post = cell.post else { return }
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        Service.shared.likePost(post: post) { (err, ref) in
            
            let likes = post.didLike ? post.likes - 1 : post.likes + 1
            cell.post?.didLike.toggle()
            cell.post?.likes = likes
            if likes != 0 {
                cell.likesCount.text = "\(likes)"
            } else {
                cell.likesCount.text = "0"
            }
            self.checkIfUserLikedTweets() // D
            //only upload notification if post is being liked
            let viewModel = PostViewModel(post: cell.post!)
            cell.likeButton.tintColor = viewModel.likeButtonTintColor
            cell.likeButton.setImage(viewModel.likeButtonImage, for: .normal)
            guard !post.didLike else { return }
            if post.user.uid != currentUser {
                NotificationService.shared.uploadNotification(type: .like, post: post)
            }
//            self.collectionView.reloadData()
            
        }
        
    }
    
    func handleCommentTap(_ cell: UpdatedPostCollectionCell) {
       guard let post = cell.post else { return }
//        let controller = PostReplyController(user: post.user, post: post)
        let controller = SelectedPostController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleProfileImageTapped(_ cell: UpdatedPostCollectionCell) {
        guard let user = cell.post?.user else { return }
//        let controller = ProfileCollectionViewController(user: user)
        let controller = NewProfileVC()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension FeedController: ActionSheetLauncherDelegate {

    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user): Service.shared.followUser(uid: user.uid) { (err, ref) in
            print("Did follow \(user.username)")
            }
        case .unfollow(let user): Service.shared.unfollowUser(uid: user.uid) { (err, ref) in
            print("Did unfollow \(user.username)")
            }
        case .report:
            let alert = UIAlertController(title: "Post Reported", message: "Successfully reported post, thank you.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .default) { (action) in
                print("Done Handled")
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        case .delete(let post):
            
            let alert = UIAlertController(title: "Delete Post", message: "Would you like to delete post?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .destructive) { (action) in
                print("Done Handled")
                Service.shared.deletePost(post: post) { (err, ref) in
                    print("Successfully deleted post \(post.postID)")
                    self.handleRefresh()
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("Done Handled")
            }
            alert.addAction(yes)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            collectionView.reloadData()
        }
    }
}

