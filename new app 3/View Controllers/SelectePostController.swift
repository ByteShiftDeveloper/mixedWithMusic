//
//  SelectePostController.swift
//  new app 3
//
//  Created by William Hinson on 5/15/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import AVKit

private let postCellIdentifier = "PostCell"
private let headerIdentifier = "PostHeader"

class SelectedPostController: UICollectionViewController {
    
    
    private let post: Post
    private var actionSheetLauncher: ActionSheetLauncher!
    
    let feedController = FeedController()
    
    var playerLayer: AVPlayerLayer?

    
    let tabBar = TabBarController()
    
  
    
    
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
    
    private var comments = [Post]() {
        didSet { collectionView.reloadData() }
    }
    
    func checkIfUserLikedPost(_ posts: Post) {
            Service.shared.checkIfUserLikedPost(post) { didLike in
            guard didLike == true else { return }
                self.post.didLike = true
//                if let index = posts.firstIndex(where: { $0.postID == post.postID}) {
//                    self.post.didLike = true
//
//                    self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])// D
//                }
            }
    }

    
    init(post: Post){
        self.post = post
        self.actionSheetLauncher = ActionSheetLauncher(user: post.user, post: post)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "CommentCell")
        
        configureCollectionView()
        fetchComments()
        configureKeyboardObservers()
        
        print("post text is \(post.text)")
        
        view.backgroundColor = UIColor(named: "DefaultBackgroundColor")
        collectionView.keyboardDismissMode = .interactive
        self.view.addGestureRecognizer(rightSwipeGesture)
        collectionView.alwaysBounceVertical = true
        //view.insertSubview(TabBarController.playersDetailView, belowSubview: containerView)

        
    }
    
    @objc func swipedRight(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            navigationController?.popViewController(animated: true)
        }
    }
    
    lazy var rightSwipeGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .right
        gesture.addTarget(self, action: #selector(swipedRight))
        return gesture
    }()
    
     lazy var containerView: CommentInputTextViewAccessory = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        let containerView = CommentInputTextViewAccessory(frame: frame)
//        containerView.layer.borderWidth = 0.5
        containerView.delegate = self
        return containerView
    }()
    
    var randomView: UIView = {
        let random = UIView()
        random.backgroundColor = .purple
        return random
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
//    private let replyText = commentInputTextField()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor(named: "BlackColor")
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.backgroundColor = UIColor(named: "DefaultBackgroundColor")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    var actionSheetShown: Bool = false
    
    fileprivate func showActionSheet(forUser user: User) {
        actionSheetLauncher = ActionSheetLauncher(user: user, post: post)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.containerView = self.containerView
        actionSheetLauncher.show()
    }

    
    func configureCollectionView() {
        collectionView.backgroundColor = UIColor(named: "DefaultBackgroundColor")
        collectionView.register(PostHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
     

    }
    
    func fetchComments() {
        Service.shared.fetchComments(forPost: post) { comments in
            self.comments = comments
        }
    }
    
    func checkIfUserLikedComment(_ comments: Comment) {
            Service.shared.checkIfUserLikedComment(comments) { didLike in
            guard didLike == true else { return }
                
//                if let index = posts.firstIndex(where: { $0.postID == post.postID}) {
//                    self.posts[index].didLike = true
//
//                    self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])// D
//                }
            }
    }

    
//    func checkIfUserLikedPost(_ posts: [Post]) {
//        posts.forEach { post in
//            Service.shared.checkIfUserLikedPost(post) { didLike in
//            guard didLike == true else { return }
//
//                if let index = posts.firstIndex(where: { $0.postID == post.postID}) {
//                    self.comments[index].didLike = true
//
//                    self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])// D
//                }
//            }
//        }
//    }
//
//    func handleLikeTap(_ cell: CommentCell) {
//        guard let post = cell.post else { return }
//
//        Service.shared.likePost(post: post) { (err, ref) in
//
//            let likes = post.didLike ? post.likes - 1 : post.likes + 1
//            cell.post?.didLike.toggle()
//
//            cell.post?.likes = likes
//            self.checkIfUserLikedPost(self.comments) // D
//            //only upload notification if post is being liked
//            guard !post.didLike else { return }
//            NotificationService.shared.uploadNotification(type: .like, post: post)
//            self.collectionView.reloadData()
//
//        }
//
//    }
    
    func configureKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    
    func scrollToBottom() {
        if comments.count > 0 {
            let indexPath = IndexPath(item: comments.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    @objc func handleKeyboardDidShow() {
        scrollToBottom()
    }
    
    func handleHashTagTapped(forHeader header: PostHeader) {
        header.postTextLabel.handleHashtagTap { hashtag in
            print("Hashtag is \(hashtag)")
          let controller = HashtagsController(collectionViewLayout: UICollectionViewFlowLayout())
          controller.hashtag = hashtag
          self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    var startingFrame: CGRect?
    var backGroundView: UIView?
    var startingImageView: UIImageView?
    
        
        func performZoomInForStartingImageView(startingImageView: UIImageView) {
            print("Performing zoom in logic controller")
            
            self.startingImageView = startingImageView
            self.startingImageView?.isHidden = true
            startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)

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
                containerView.isHidden = true
//                statusBarUIView?.backgroundColor = .black
            
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
                        self.containerView.isHidden = false
//                        self.statusBarUIView?.backgroundColor = .white


                        }
                    })
                }
            }
        }
}

extension SelectedPostController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.post = comments[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension SelectedPostController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var height : CGFloat = 155
        
        height += textHeight(text: post.text)
        
        if post.picture != "" && post.postURL == "" && post.video == ""{
            height += 317
        } else if post.picture == "" && post.postURL == "" && post.video != "" {
            height += 317
        }else if post.picture == "" && post.postURL != "" && post.video == "" {
            height += 317
        }  else if post.songID != "" {
            height += 150
        } else if post.text == "" {
            height -= 20
        }
        
        return CGSize(width: view.frame.width, height: height)
        
//        return CGSize(width: view.frame.height, height: 527)
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          var height : CGFloat = 45

                height += textHeight(text: post.text)

//                if post.picture != ""{
//                    height += 317
//                }
                
                return CGSize(width: view.frame.width, height: height)
      }
}


extension SelectedPostController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! PostHeader
        header.post = post
        header.delegate = self
        header.postController = self
        handleHashTagTapped(forHeader: header)
        return header
    }
}

extension SelectedPostController{
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

extension SelectedPostController: PostHeaderDelegate {
    func handleLikeTap(_ header: PostHeader) {
        
        Service.shared.likePost(post: post) { (err, ref) in
            
            let likes = self.post.didLike ? self.post.likes - 1 : self.post.likes + 1
            header.post?.didLike.toggle()
//            header.likeButton.pulsate()
            header.post?.likes = likes
            let viewModel = PostViewModel(post: header.post!)
            header.likesLabel.attributedText = viewModel.likesAttributedString
            header.likeButton.tintColor = viewModel.likeButtonTintColor
            header.likeButton.setImage(viewModel.likeButtonImage, for: .normal)
            header.post?.likes = likes
            self.checkIfUserLikedPost(self.post) // D
            //only upload notification if post is being liked
            guard !self.post.didLike else { return }
            NotificationService.shared.uploadNotification(type: .like, post: self.post)
            self.collectionView.reloadData()
            
        }
    }
    
    
    func handleSongTap(_ header: PostHeader) {
        let post = header.post
        Service.shared.fetchUpload(withSongID: post!.songID) { (song) in
            let y = self.view.frame.height   - 64
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.addPlayerView(song: song)
            
//            TabBarController.playersDetailView.handleTapMaximize()
//            TabBarController.playersDetailView.song = song
        }
    }
    
    
    func handleVideoPlay(_ header: PostHeader) {
        
        guard let videoURL = URL(string: post.video) else { return }
        let launcher = VideoLauncher()
        launcher.videoUrl = videoURL
        print("THIS IS THE VIDEO URL \(videoURL)")
        launcher.showVideoPlayer()
        containerView.isHidden = true
//        statusBarUIView?.backgroundColor = .black
        
        
//        let player = AVPlayer(url: videoURL)
//        let videoPlayer = AVPlayerViewController()
//        videoPlayer.player = player
//        self.present(videoPlayer, animated: true) {
//            player.play()
//        }
        
        print("attempting to play video")

    }
    
    
    func handleImageZoom(_ header: PostHeader) {
        print("image is zooming in")
    }
    
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUserByUserName(withUsername: username) { user in
            let controller = ProfileCollectionViewController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    func handleProfileImageTapped(_ header: PostHeader) {
        let user = post.user
        let controller = NewProfileVC()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func showActionSheet() {
        self.containerView.isHidden = true
        if post.user.isCurrentUser {
            showActionSheet(forUser: post.user)

        } else {
            Service.shared.checkIfUserIsFollowed(uid: post.user.uid) { isFollowed in
                let user = self.post.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
            }

        }

    }
    
    
}

extension SelectedPostController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        self.containerView.isHidden = false
        switch option {
        case .follow(let user): Service.shared.followUser(uid: user.uid) { (err, ref) in
            print("Did follow \(user.username)")
            }
        case .unfollow(let user): Service.shared.unfollowUser(uid: user.uid) { (err, ref) in
            print("Did unfollow \(user.username)")
            }
        case .report:
            print("report")
        case .delete(let post):
            print("delete")
            let alert = UIAlertController(title: "Delete Post", message: "Would you like to delete post?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .destructive) { (action) in
                print("Done Handled")
                Service.shared.deletePost(post: post) { (err, ref) in
                    print("Successfully deleted post \(post.postID)")
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
            
            alert.addAction(yes)
            present(alert, animated: true, completion: nil)
        }
        
    }
}

extension SelectedPostController: MessageInputAccesoryViewDelegate {
    func handleUploadMessage(message: String) {
        let postID = post.postID
//        guard let replyText = replyText.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let comments = post.didComment ? post.comments + 1 : post.comments + 1
        let ref = Database.database().reference().child("post-comments")
        POSTS_REF.child(post.postID).child("comments").setValue(comments)
        let creationDate = Int(NSDate().timeIntervalSince1970)

        let values = ["commentID": ref.key,
                      "text": message,
                      "timestampt": creationDate,
                      "likes": 0,
                      "reposts": 0,
                      "uid": uid] as [String : Any]

       ref.child(postID).childByAutoId().updateChildValues(values)
            
        NotificationService.shared.uploadNotification(type: .comment, post: post)
        
        self.containerView.clearMessageTextView()
    }
    
    func handleSelectImage() {
        print("")
    }
}

extension SelectedPostController: CommentDelegate {
    func handleProfileImageTapped(_ cell: CommentCell) {
        let user = post.user
        let controller = NewProfileVC()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)

    }
    
    func handleCommentTap(_ cell: CommentCell) {
        
    }
    
    func handleLikeTap(_ cell: CommentCell) {
        print("Trying to tap this like button")
        
//        let post = self.post
//        Service.shared.likeComment(post: post) { (err, ref) in
//
//            let likes = post.didLike ? post.likes - 1 : post.likes + 1
//            cell.post?.didLike.toggle()
//            cell.likeButton.pulsate()
//
//            cell.post?.likes = likes
//            self.checkIfUserLikedPost(self.posts) // D
//            //only upload notification if post is being liked
//            guard !post.didLike else { return }
//            NotificationService.shared.uploadNotification(type: .like, post: post)
//            self.collectionView.reloadData()
//
//        }
    }
    
    
}
