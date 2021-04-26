//
//  File.swift
//  new app 3
//
//  Created by William Hinson on 5/6/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import AVKit
//private let reuseIdentifier = "PostCell"

private let postCellIdentifier = "PostCell"
private let headerIdentifier = "ProfileViewHeader"
private let headerIdentifier2 = "singleProfileUploadHeader"
private let ProfileFeedCollectionViewCell = "PostCell"
private let userUploadCell = "userUploadsCell"

let offset_HeaderStop:CGFloat = 200 - 64  // At this offset the Header stops its transformations


class ProfileCollectionViewController: UICollectionViewController {
    
    var user: User?
    var userToLoadFromSearchVC: User?
    
    let filterBar = ProfileFilterView()
    
    let header = ProfileViewHeader()
        

    
//    var posts = [Posts]()
    
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
    
    init(user: User) {
           self.user = user
           super.init(collectionViewLayout: UICollectionViewFlowLayout())
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    private var selectedFilter: ProfileFilterOptions = .posts {
        didSet { collectionView.reloadData() }
    }
    
    private var posts = [Post]()
    private var likedPosts = [Post]()
    private var uploads = [SongPost]()
    private var albums = [SongPost]()
    
    private var currentDataSource: [AnyObject] {
        switch selectedFilter {

        case .posts:
            return posts
        case .uploads:
            return uploads
        case .likes:
            return likedPosts
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        checkUserIsFollowed()
        fetchUserStats()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.fetchPost()
            self.fetchLikedPosts()
    //        fetchUploads()
            self.fetchSingle()
            self.fetchAlbums()

        }
        
        self.collectionView.automaticallyAdjustsScrollIndicatorInsets = false
//        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
//        layout?.sectionHeadersPinToVisibleBounds = true
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
       
        
        collectionView.register(UpdatedPostCollectionCell.self, forCellWithReuseIdentifier: "PostCell")
        collectionView.register(ProfileUploadsCell.self, forCellWithReuseIdentifier: userUploadCell)
        
        
        self.view.addGestureRecognizer(leftSwipeGesture)
        self.view.addGestureRecognizer(rightSwipeGesture)
    
    }
    
    @objc func swipedLeft(sender: UISwipeGestureRecognizer) {
            if sender.state == .ended {
                print("Swiped left")
            }
        }
        
        @objc func swipedRight(sender: UISwipeGestureRecognizer) {
            if sender.state == .ended {
                print("Swiped right")
            }
        }
    
    lazy var leftSwipeGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .left
        gesture.addTarget(self, action: #selector(swipedLeft))
        return gesture
    }()
    
    lazy var rightSwipeGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .right
        gesture.addTarget(self, action: #selector(swipedRight))
        return gesture
    }()

    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let button = UIBarButtonItem(image: (UIImage(systemName: "chevron.left")), style: .plain, target: self, action: #selector(handDismissal))
//        navigationItem.setLeftBarButton(button, animated: true)
////        navigationController?.navigationBar.barStyle = .black
//        navigationController?.navigationBar.isHidden = false
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        let button = UIBarButtonItem(image: (UIImage(systemName: "chevron.left")), style: .plain, target: self, action: #selector(handDismissal))
        navigationItem.setLeftBarButton(button, animated: true)
       self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
       self.navigationController?.navigationBar.shadowImage = UIImage()
       self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.tintColor = .clear
       self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        self.statusBarUIView?.backgroundColor = .clear


        self.navigationItem.title = user?.fullname
               
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.shadowImage = nil

    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(ProfileViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(singleProfileUploadHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier2)
//        collectionView.register(UpdatedPostCollectionCell.self, forCellWithReuseIdentifier: ProfileFeedCollectionViewCell)
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
        collectionView.alwaysBounceVertical = true
        collectionView.bounces = true
        
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: view.center.x, y: view.center.y, width: view.frame.width, height: view.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        collectionView.backgroundView = emptyView
    }
        func restore() {
        collectionView.backgroundView = nil
    }
    
    @objc func handDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: -API

    
    func checkUserIsFollowed() {
        Service.shared.checkIfUserIsFollowed(uid: user!.uid) { isFollowed in
            self.user?.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        Service.shared.fetchUserStats(uid: user!.uid) { stats in
            self.user?.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    func fetchCurrentUserData() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
               
               Database.database().reference().child("users/profile").child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
                  guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                  let uid = snapshot.key
                  let user = User(uid: uid, dictionary: dictionary)
                  self.user = user
        }
    }
    
    func fetchPost() {
        Service.shared.fetchUserPost(forUser: user!) { posts in
            self.posts = posts.sorted(by: { $0.createdAt > $1.createdAt})
            self.collectionView.reloadData()
        }
    }
    
    func showChatController(forUser user: User) {
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        navigationController?.pushViewController(chatController, animated: true)
    }
    
//    func fetchUploads() {
//        Service.shared.fetchUserUploads(forUser: user) { uploads in
//            self.uploads = uploads
//            print("these are the uploads \(uploads)")
//
//        }
//    }
    
    func uploadFetch() {
        
        USER_UPLOADS.child(user!.uid).observe(.childAdded) { snapshot in
                   let uploadID = snapshot.key
            
            print("upload id id \(uploadID)")
            
            UPLOADS_REF.child(uploadID).observeSingleEvent(of: .value) { snapshot in
                print("audio is \(snapshot)")

                    guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                                      
            
                                //                      let author = dict["uploadBy"] as? [String:Any],
                                        guard let uid = dictionary["uid"] as? String else { return }
                                        guard let fullname = dictionary["username"] as? String else { return }
                                        guard let photoURL = dictionary["photoURL"] as? String else { return }
                                        guard let trackTitle = dictionary["trackTitle"] as? String else { return }
                                        guard let url = URL (string:photoURL) else { return }
                                        guard let coverImageURL = dictionary["coverImage"] as? String else { return }
                                        guard let imageURL = URL (string:coverImageURL) else { return }
                                        guard let audios = dictionary["AudioUrl"] as? [[String:Any]] else { return }
                                        guard let likes = dictionary["likes"] as? Int else { return }
                                        guard let streams = dictionary["streams"] as? Int else { return }


                                                          //let songURL = URL (string:audioURL),
                                      
                                        guard let  timestamp = dictionary["timestampt"] as? Double else { return }; do {
                                      
                                        var audioNames  = [String]()
                                        var audioUrls  = [URL]()
                                        for audio in audios{
                                        let audioName = audio.first?.key
                                        let audioUrl = audio.first?.value as? String
                                        let songURL = URL (string:audioUrl!)
                                      
                                        audioNames.append(audioName!)
                                        audioUrls.append(songURL!)
                                }
                                      
                                UserService.shared.fetchUser(uid: uid) { user in
                                
                                    let song = SongPost(id: snapshot.key, author: user, title: trackTitle, coverImage: imageURL, audioUrl: audioUrls , audioName: audioNames, likes: likes , timestamp: timestamp, streams: streams)
                                self.uploads.append(song)

                    }
                }
            }
        }
    }
    
    func fetchSingle() {
          
        SINGLE_UPLOADS.child(user!.uid).observe(.childAdded) { snapshot in
                     let uploadID = snapshot.key
              
              print("upload id id \(uploadID)")
              
              UPLOADS_REF.child(uploadID).observeSingleEvent(of: .value) { snapshot in
                  print("audio is \(snapshot)")

                      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                                        
              
                                  //                      let author = dict["uploadBy"] as? [String:Any],
                                          guard let uid = dictionary["uid"] as? String else { return }
                                          guard let fullname = dictionary["username"] as? String else { return }
                                          guard let photoURL = dictionary["photoURL"] as? String else { return }
                                          guard let trackTitle = dictionary["trackTitle"] as? String else { return }
                                          guard let url = URL (string:photoURL) else { return }
                                          guard let coverImageURL = dictionary["coverImage"] as? String else { return }
                                          guard let imageURL = URL (string:coverImageURL) else { return }
                                          guard let audios = dictionary["AudioUrl"] as? [[String:Any]] else { return }
                                          guard let likes = dictionary["likes"] as? Int else { return }
                                          guard let streams = dictionary["streams"] as? Int else { return }


                                                            //let songURL = URL (string:audioURL),
                                        
                                          guard let  timestamp = dictionary["timestampt"] as? Double else { return }; do {
                                        
                                          var audioNames  = [String]()
                                          var audioUrls  = [URL]()
                                          for audio in audios{
                                          let audioName = audio.first?.key
                                          let audioUrl = audio.first?.value as? String
                                          let songURL = URL (string:audioUrl!)
                                        
                                          audioNames.append(audioName!)
                                          audioUrls.append(songURL!)
                                  }
                                        
                                  UserService.shared.fetchUser(uid: uid) { user in
                                  
                                    let song = SongPost(id: snapshot.key, author: user, title: trackTitle, coverImage: imageURL, audioUrl: audioUrls , audioName: audioNames, likes: likes , timestamp: timestamp, streams: streams)
                                  self.uploads.append(song)

                      }
                  }
              }
          }
      }
    
    func fetchAlbums() {
          
        ALBUM_UPLOADS.child(user!.uid).observe(.childAdded) { snapshot in
                     let uploadID = snapshot.key
              
              print("upload id id \(uploadID)")
              
              UPLOADS_REF.child(uploadID).observeSingleEvent(of: .value) { snapshot in
                  print("audio is \(snapshot)")

                      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                                        
              
                                  //                      let author = dict["uploadBy"] as? [String:Any],
                                          guard let uid = dictionary["uid"] as? String else { return }
                                          guard let fullname = dictionary["username"] as? String else { return }
                                          guard let photoURL = dictionary["photoURL"] as? String else { return }
                                          guard let trackTitle = dictionary["trackTitle"] as? String else { return }
                                          guard let url = URL (string:photoURL) else { return }
                                          guard let coverImageURL = dictionary["coverImage"] as? String else { return }
                                          guard let imageURL = URL (string:coverImageURL) else { return }
                                          guard let audios = dictionary["AudioUrl"] as? [[String:Any]] else { return }
                                          guard let likes = dictionary["likes"] as? Int else { return }
                                          guard let streams = dictionary["streams"] as? Int else { return }

                
                                                            //let songURL = URL (string:audioURL),
                                        
                                          guard let  timestamp = dictionary["timestampt"] as? Double else { return }; do {
                                        
                                          var audioNames  = [String]()
                                          var audioUrls  = [URL]()
                                          for audio in audios{
                                          let audioName = audio.first?.key
                                          let audioUrl = audio.first?.value as? String
                                          let songURL = URL (string:audioUrl!)
                                        
                                          audioNames.append(audioName!)
                                          audioUrls.append(songURL!)
                                  }
                                        
                                  UserService.shared.fetchUser(uid: uid) { user in
                                  
                                    let song = SongPost(id: snapshot.key, author: user, title: trackTitle, coverImage: imageURL, audioUrl: audioUrls , audioName: audioNames, likes: likes , timestamp: timestamp, streams: streams)
                                  self.albums.append(song)

                      }
                  }
              }
          }
      }
    
    func fetchLikedPosts() {
        Service.shared.fetchLikes(forUser: user!) { posts in
            self.likedPosts = posts
        }
    }
    
    func handleHashTagTapped(forCell cell: UpdatedPostCollectionCell) {
        cell.postTextLabel.handleHashtagTap { hashtag in
            print("Hashtag is \(hashtag)")
          let controller = HashtagsController(collectionViewLayout: UICollectionViewFlowLayout())
          controller.hashtag = hashtag
          self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    //MARK: -ScrollView
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y / 175
        if offset > 1 {
            offset = 1
            let color  = UIColor(hue: 0, saturation: offset, brightness: 0, alpha: 1)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
            self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
            statusBarUIView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
            print(scrollView.contentOffset.y)

        } else {
//            let color  = UIColor(hue: 0, saturation: offset, brightness: 0, alpha: 1)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
            self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
            statusBarUIView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
        }
//        let filterViewOffset = header.frame.height - filterBar.frame.height
//
//        var segmentTransform = CATransform3DIdentity
//
//        segmentTransform = CATransform3DTranslate(segmentTransform, 0, max(filterViewOffset, -offset_HeaderStop), 0)
//
//        filterBar.layer.transform = segmentTransform
//
//        print("The offset is this \(filterViewOffset)")
        
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: filterBar.frame.maxY, left: 0, bottom: 0, right: 0)
    }
    
    var startingFrame: CGRect?
    var backGroundView: UIView?
    var startingImageView: UIImageView?
    
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
//        print(startingFrame)
        
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
}

//MARK: -Extensions

extension ProfileCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if selectedFilter == .posts {
            if currentDataSource.count == 0 {
                setEmptyView(title: "There are no posts", message: "Posts will appear here")
            } else {
             restore()
            }
            
            return currentDataSource.count
        } else if selectedFilter == .likes {
            return currentDataSource.count
        } else {
            if section == 0 {
             return 0
            } else if section == 2 {
                return albums.count
            } else {
                return currentDataSource.count
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if selectedFilter == .uploads {
            return 3
        } else {
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedFilter == .posts {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! UpdatedPostCollectionCell
        cell.post = currentDataSource[indexPath.row] as? Post
        cell.delegate = self
        handleHashTagTapped(forCell: cell)
        return cell
        } else if selectedFilter == .likes {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! UpdatedPostCollectionCell
        cell.post = currentDataSource[indexPath.row] as? Post
        cell.delegate = self
        handleHashTagTapped(forCell: cell)
        return cell
        } else {
            if indexPath.section == 0 {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            return cell
            } else if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userUploadCell, for: indexPath) as! ProfileUploadsCell
            cell.song = currentDataSource[indexPath.row] as? SongPost
            return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userUploadCell, for: indexPath) as! ProfileUploadsCell
                cell.song = albums[indexPath.row] as SongPost
                return cell
                }
            }
        }
    }

extension ProfileCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileViewHeader
        header.delegate = self
        header.profileController = self
        header.user = self.user
        return header
        } else if indexPath.section == 1 {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier2, for: indexPath) as! singleProfileUploadHeader
            header.fullnameLabel.text = "Singles"
        return header
        } else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier2, for: indexPath) as! singleProfileUploadHeader
            header.fullnameLabel.text = "Albums and EPs"
            return header
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedFilter == .uploads {
            if indexPath.section == 2 {
                let controller = SelectSongController(collectionViewLayout: StretchyHeaderLayout())
                controller.song = albums[indexPath.row]
                controller.user = albums[indexPath.row].author
                navigationController?.pushViewController(controller, animated: true)
            } else {
            guard let song = currentDataSource[indexPath.row] as? SongPost else { return }
       
                let y = self.view.frame.height  - 64
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                appDelegate.addPlayerView(song: song)

//                    TabBarController.playersDetailView.handleTapMaximize()
//                    TabBarController.playersDetailView.song = song
            }
        } else {
             let controller = SelectedPostController(post: currentDataSource[indexPath.row] as! Post)
           navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension ProfileCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
        var height: CGFloat = 385
        
            if user?.bio != nil {
            height += 62
        }
        
        return CGSize(width: view.frame.height, height: height)
        } else {
           
            return CGSize(width: view.frame.height, height: 40)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if selectedFilter == .posts {
            var height : CGFloat = 140
                let post = currentDataSource[indexPath.row] as! Post

                height += textHeight(text: post.text)

            if post.picture != "" && post.video == ""{
                height += 317
            } else if post.picture == "" && post.video != "" {
                height += 317
            }
                         
            return CGSize(width: view.frame.width, height: height)
        }  else if selectedFilter == .likes {
            var height : CGFloat = 140
                let post = currentDataSource[indexPath.row] as! Post

                height += textHeight(text: post.text)

            if post.picture != "" && post.video == ""{
                height += 317
            } else if post.picture == "" && post.video != "" {
                height += 317
            }
            return CGSize(width: view.frame.width, height: height)
        } else {
            if indexPath.section == 0 {
                return CGSize(width: view.frame.width, height: 0)

            } else {
            return CGSize(width: view.frame.width, height: 60)
            }
        }
       
    }
    
}

extension ProfileCollectionViewController: ProfileViewHeaderDelegate {
    func handleMessageTap(_ header: ProfileViewHeader) {
        print("tapped")
        guard let user = user else { return }
        self.showChatController(forUser: user)
    }
    
    func handleHeaderImageZoom(_ header: ProfileViewHeader) {
        print("Image is being tapped")
    }
    
    func handleImageZoom(_ header: ProfileViewHeader) {
        print("Image is being tapped")
    }
    
    
    func folliwngTapped(_ header: ProfileViewHeader) {
        print("Following Tapped")
        let controller = Following()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func followersTapped(_ header: ProfileViewHeader) {
        print("Followers Tapped")
        let controller = Followers()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didSelect(filter: ProfileFilterOptions) {
        self.selectedFilter = filter
    }
    
   
    
    func editProfileFollowButton(_ header: ProfileViewHeader) {
                
        if user!.isCurrentUser {
            let controller = EditProfileTableViewController(user: user!)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
            return
        }
        
        if user!.isFollowed {
            Service.shared.unfollowUser(uid: user!.uid) { (err, ref) in
                self.user?.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            Service.shared.followUser(uid: (user!.uid)) { (ref, err) in
                self.user?.isFollowed = true
              self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(type: .follow, user: self.user)
            }
        }
    }
    
    func handleDismiss(_ header: ProfileViewHeader) {
        print("this is working")
    }
}

extension ProfileCollectionViewController{
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

extension ProfileCollectionViewController: PostDelegate {
    
    func handleSongTap(_ cell: UpdatedPostCollectionCell) {
        
    }
    
    func handleActionSheet(_ cell: UpdatedPostCollectionCell) {
        print("tapped")
    }
    
    func handlePlayTapped(_ cell: UpdatedPostCollectionCell) {
        guard let post = cell.post else { return }
        guard let videoURL = URL(string: post.video) else { return }
        let player = AVPlayer(url: videoURL)
        let videoPlayer = AVPlayerViewController()
        videoPlayer.player = player
        self.present(videoPlayer, animated: true) {
            player.play()
        }
    }
    func handleRepostTapped(_ cell: UpdatedPostCollectionCell) {
        print("Repost clicked")
    }
    
    func handleImageZoom(_ cell: UpdatedPostCollectionCell) {
        print("Image is being tapped")

    }
    
    func handleShareTap(_ cell: UpdatedPostCollectionCell) {
        print("Tapped")

    }
    
       func handleNameTap(_ cell: UpdatedPostCollectionCell) {
    //        guard let user = cell.post?.user else { return }
    //        let controller = ProfileCollectionViewController(user: user)
    //        navigationController?.pushViewController(controller, animated: true)
            print("This was tapped")

        }
        
        func handleFetchUser(withUsername username: String) {
            UserService.shared.fetchUserByUserName(withUsername: username) { user in
                let controller = ProfileCollectionViewController(user: user)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        func handleLikeTap(_ cell: UpdatedPostCollectionCell) {
            guard let post = cell.post else { return }
            
            Service.shared.likePost(post: post) { (err, ref) in
                cell.post?.didLike.toggle()
                let likes = post.didLike ? post.likes - 1 : post.likes + 1
                cell.post?.likes = likes
                
                //only upload notification if post is being liked
                guard !post.didLike else { return }
                NotificationService.shared.uploadNotification(type: .like, post: post)
            }
            
        }
        
        func handleCommentTap(_ cell: UpdatedPostCollectionCell) {
           guard let post = cell.post else { return }
            let controller = PostReplyController(user: post.user, post: post)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
        
        func handleProfileImageTapped(_ cell: UpdatedPostCollectionCell) {
            guard let user = cell.post?.user else { return }
            let controller = ProfileCollectionViewController(user: user)
            navigationController?.pushViewController(controller, animated: true)
        }
}

extension ProfileCollectionViewController: EditProfileControllerDelegate {
    
    func controller(_ controller: EditProfileTableViewController, wantsToUpdate user: User) {
          controller.dismiss(animated: true, completion: nil)
          self.user = user
          self.collectionView.reloadData()
      }
}
