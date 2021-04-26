//
//  HomeViewController.swift
//  new app 3
//
//  Created by William Hinson on 1/3/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import Firebase


protocol HomeControllerDelegate: class {
    func handleMenuToggle()
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FeedCellDelegate {

    
    weak var delegate: HomeControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    var replypost:NSDictionary?
    
    var user: User? {
        didSet { congfigureUI()}
    }

    private var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }
    var fetchingMore = false
    var endReached = false
    let leadingScreensForBatching:CGFloat = 1.0
    
    var isOn = false
    var toggleState = 1
    
    var cellHeights: [IndexPath: CGFloat] = [:]
    
    var layoutGuide:UILayoutGuide?

    
    var refreshControl:UIRefreshControl!
    
    var seeNewPostsButton:SeeNewPostsButton!
    var seeNewPostsButtonTopAnchor:NSLayoutConstraint!
    
    var lastUplaodedPostID:String?
    var lastProfilePhoto:String?
    var currentProfilePhoto:String?
    var didProfileChanged:Bool = false
    
//    var firstPost:Post?
//    var lastPost:Post?
    
    var postsRef:DatabaseReference {
        return Database.database().reference().child("posts")
    }
    
//    var oldPostsQuery:DatabaseQuery {
//        let lastPost = self.posts.last
//        let lastPostID = lastPost?.postID
//               var queryRef:DatabaseQuery
//               if lastPost == nil {
//                   queryRef = postsRef.queryOrdered(byChild: "timestamp")
//               } else {
//                print("last post\(lastPostID)")
//                   let lastTimestamp = lastPost!.createdAt.timeIntervalSince1970 * 1000
//                queryRef = postsRef.queryOrderedByKey().queryEnding(atValue: lastPostID)
//               }
//        return queryRef
//    }
//
//    var newPostsQuery:DatabaseQuery {
//        let firstPost = posts.first
//               var queryRef:DatabaseQuery
//               if firstPost == nil {
//                   queryRef = postsRef.queryOrdered(byChild: "timestamp")
//               } else {
//                   let firstTimestamp = firstPost!.createdAt.timeIntervalSince1970 * 1000
//                   queryRef = postsRef.queryOrdered(byChild: "timestamp").queryStarting(atValue: firstTimestamp)
//               }
//        return queryRef
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        congfigureUI()
        
        fetchPosts()
        
        guard let tabBar = self.tabBarController?.tabBar else { return }
               
               tabBar.tintColor = UIColor.black
               tabBar.barTintColor = UIColor.white
        

        // Do any additional setup after loading the view
        let cellNib =  UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
//        tableView.register(LoadingCell.self, forCellReuseIdentifier: "loadingCell")
        
        
      
//        let layoutGuide = self.view.safeAreaLayoutGuide
        
        tableView.reloadData()
        
        
        refreshControl = UIRefreshControl()
//        tableView.refreshControl = refreshControl
//        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
//
//        seeNewPostsButton = SeeNewPostsButton()
//                    view.addSubview(seeNewPostsButton)
//        seeNewPostsButton.translatesAutoresizingMaskIntoConstraints = false
//        seeNewPostsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//        seeNewPostsButtonTopAnchor = seeNewPostsButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: -44)
//       seeNewPostsButtonTopAnchor.isActive = true
//        seeNewPostsButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
//        seeNewPostsButton.widthAnchor.constraint(equalToConstant: seeNewPostsButton.button.bounds.width).isActive = true
//        seeNewPostsButton.button.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
//
//        //observe the posts
//        beginBatchFetch()
//
//        view.hideSkeleton()
//
//  NotificationCenter.default.addObserver(self, selector: #selector(loadAgain), name: NSNotification.Name("UserInfoChanged"), object: nil)
        
    }
    
    func fetchPosts() {
        Service.shared.fetchPosts { posts in
            self.posts = posts
        }
    }
    
    func congfigureUI() {
        
        guard let user = user else { return }
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .lightGray
        profileImageView.setDimensions(width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.loadImage(with: user.profileImageURL)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
//    func getFirebaseData(){
//
//              guard let uid = Auth.auth().currentUser?.uid else { return }
//        let databaseRef = Database.database().reference()
//              databaseRef.child("users/profile").child(uid).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
//                  let dict = snapshot.value as? [String:Any]
//
//                  if(dict!["photoURL"] != nil) {
//
//                  let databaseProfilePic = dict!["photoURL"] as! String
//
//                    self.profileImage.loadImage(with: databaseProfilePic)
//                    self.profileImage.layer.cornerRadius = self.profileImage.bounds.height / 2
//                    self.profileImage.layer.masksToBounds = true
//                }
//        }
//    }
    
    
    @IBAction func messageButtonPressed(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "MessagesTableViewController") as! MessagesTableViewController
              
              
              let navigationcontroller = UINavigationController(rootViewController: vc)
                     navigationcontroller.modalPresentationStyle = .fullScreen
                     self.present(navigationcontroller, animated: true, completion: nil)
        
    }
    
        

    
//    @objc func loadAgain(){
//
//        self.posts.removeAll()
//
//        fetchAgain{ post in
//            self.posts = post
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//
//            }
//        }
//    }
    
//    func fetchAgain(completion: @escaping(_ posts:[Post])->()){
//
//        let ref = Database.database().reference().child("posts")
//        oldPostsQuery.queryLimited(toLast: 20).observeSingleEvent(of: .value, with: { snapshot in
//            var tempPosts = [Post]()
//
//
//            for child in snapshot.children {
//                let childSnapshot = child as? DataSnapshot
//                let data = childSnapshot?.value as? [String:Any]
//                let post = Post.parse(childSnapshot!.key, data!)
//
//                tempPosts.insert(post!, at: 0)
//                }
//                return completion(tempPosts)
//
//                })
//    }
    
    
    
 
 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//       listenForNewPosts()
     

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        stopListeningForNewPosts()
    }
    
//    func toggleSeeNewPostsButton(hidden:Bool){
//        if hidden{
//            // hide it
//
//            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//                self.seeNewPostsButtonTopAnchor.constant = -44.0
//                self.view.layoutIfNeeded()
//            }, completion: nil)
//        } else {
//            // show it
//            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//                self.seeNewPostsButtonTopAnchor.constant = 12
//                self.view.layoutIfNeeded()
//            }, completion: nil)
//        }
//    }
//


    
//    @objc func handleRefresh() {
//    print("refresh")
//
//        toggleSeeNewPostsButton(hidden: true)
//
//        let ref = Database.database().reference().child("posts").queryLimited(toLast: 1)
//            ref.observe(.value){ snapshot in
//                      var tempPosts = [Post]()
////                            print(snapshot)
//                    let firstPost = self.posts.first
////                print("first key\(firstPost?.id)")
//
//
//                for child in snapshot.children {
//                    if let childSnapshot = child as? DataSnapshot,
//                        let data = childSnapshot.value as? [String:Any],
//                        let post = Post.parse(childSnapshot.key, data),
//                        childSnapshot.key != firstPost?.postID{
//                    tempPosts.insert(post, at: 0)
////                    print("key\(childSnapshot.key)")
//                        if self.posts.count > 0{
//                            self.posts.removeLast()
//                        }
//
//
//
//                    }
//
//                }
////                print("temp count \(tempPosts.count)")
//
////        newPostsQuery.queryLimited(toFirst: 20).observeSingleEvent(of: .value, with: { snapshot in
////        var tempPosts = [Post]()
////            print(snapshot)
////
////        let firstPost = self.posts.first
////            print(firstPost!.text)
////
////
////        for child in snapshot.children {
////            print("post count\(self.posts.count)")
////
////
////            if let childSnapshot = child as? DataSnapshot,
////                let data = childSnapshot.value as? [String:Any],
////                let post = Post.parse(childSnapshot.key, data),
////                childSnapshot.key != firstPost?.id {
////
////
////                tempPosts.insert(post, at: 0)
////            }
////        }
////            //return completion(tempPosts)
//            self.posts.insert(contentsOf: tempPosts, at: 0)
////
////                print("post count\(self.posts.count)")
////                self.beginBatchFetch()
////                self.tableView.reloadData()
////
////
////            let newIndexPaths = (0..<tempPosts.count).map { i in
////                return IndexPath(row: i, section: 0)
////            }
////
//            self.tableView.reloadData()
//
////            self.tableView.insertRows(at: newIndexPaths, with: .top)
//                self.refreshControl.endRefreshing()
//                self.tableView.scrollToRow(at: IndexPath(row: 0, section:0), at: .top, animated: true)
//
//            self.listenForNewPosts()
//
//        }
//
//
//
//
//
//    }
    

 
//
//    func fetchPosts(completion: @escaping(_ posts:[Post])->()) {
//
//        let ref = Database.database().reference().child("posts")
//        oldPostsQuery.queryLimited(toLast: 20).observeSingleEvent(of: .value, with: { snapshot in
//
//            var tempPosts = [Post]()
//
//            let lastPost = self.posts.last
////            print("last post\(lastPost)" )
////            self.lastPost = self.posts.last
//            print("posts count\(self.posts.count)")
//            for child in snapshot.children {
//                if let childSnapshot = child as? DataSnapshot,
//                    let data = childSnapshot.value as? [String:Any],
//                    let post = Post.parse(childSnapshot.key, data),
//                    childSnapshot.key != lastPost?.postID {
//
//
//                    tempPosts.insert(post, at: 0)
//               }
////                let photoUrl = UserService.currentUserProfile?.photoURL
////                self.lastProfilePhoto = photoUrl!.absoluteString
////                self.checkForPhotoChanges{ abc in
////                self.lastProfilePhoto = abc
////                }
//            }
//            return completion(tempPosts)
//
//        })
//    }
    
    
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        let vc = ReplyViewController()
//        self.present(vc, animated: true, completion: nil)
//    }
    
    func handleCommentTapped(for cell: PostTableViewCell) {
        guard let postID = cell.postID else { return }
        
        let vc = storyboard?.instantiateViewController(identifier: "ReplyViewController") as! ReplyViewController
        
//        vc.postID = postID
        
        let navigationcontroller = UINavigationController(rootViewController: vc)
               navigationcontroller.modalPresentationStyle = .fullScreen
               self.present(navigationcontroller, animated: true, completion: nil)
        
       }
    
       
       func handleLikeTapped(for cell: PostTableViewCell) {
        guard let post = cell.post else { return }
        let postId = post.postID
                if post.didLike {
                    post.adjustLikes(addLike: false) { (likes) in
                    cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    cell.likeButton.tintColor = .lightGray
                        cell.likeCountLabel.text = "\(likes)"
                    }

          } else {
                    post.adjustLikes(addLike: true) { (likes) in
                    cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    cell.likeButton.tintColor = .red
                    cell.likeCountLabel.text = "\(likes)"
                    }
        }
        
       }
    
    func handleConfigureLikeButton(for cell: PostTableViewCell) {
        guard let post = cell.post else { return }
        guard let postId = cell.post?.postID else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_LIKES_REF.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.hasChild(postId) {
                post.didLike = true
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                cell.likeButton.tintColor = .red
            }
        }
    }
    
    func handleShowLikes(for cell: PostTableViewCell) {
         let showLikesController = ShowLikesTableViewController()
          navigationController?.pushViewController(showLikesController, animated: true)
      }
    
    func handleProfileImageTap(for cell: PostTableViewCell) {
        guard let user = cell.post?.user else { return }
        let controller = ProfileCollectionViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
        
    }

        
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return
//    }
    
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }
//
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
            cell.set(post: self.posts[indexPath.row])
            cell.postID = self.posts[indexPath.row].postID
            
            cell.delegate = self
            
            
            
//            for person in self.posts[indexPath.row].peopleWhoLike {
//                if person == Auth.auth().currentUser!.uid {
//                    cell.likeButton.isHidden = true
//                    cell.unlikeButton.isHidden = false
//                }
//            }
            
//            cell.commentButton.addTarget(self, action: #selector(HomeViewController.goToReply), for: .touchUpInside)
//            cell.likeButton.addTarget(self, action: #selector(HomeViewController.likePost), for: .touchUpInside)
            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
//            cell.spinner.startAnimating()
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let controller = SelectedPostController(post: posts[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
        
    }

    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        cellHeights[indexPath] = cell.frame.size.height

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       return cellHeights[indexPath] ?? 72.0

    }
    
    
   
           
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//
//
//        let contentHeight = scrollView.contentSize.height
////        print("offsetY \(offsetY)\n") 8.33
////            print("contentsHeight \(contentHeight)\n") 216
////            print("scrollview \(scrollView.frame.size.height )\n") 725
////            print("Leading Screen for Batching \(leadingScreensForBatching)\n")
//
//
//        if offsetY > contentHeight - scrollView.frame.size.height * leadingScreensForBatching {
//            if !fetchingMore && !endReached {
//                beginBatchFetch()
//            }
//        }
    }
     
 
    
//    func beginBatchFetch() {
//        fetchingMore = true
//        //fetch post
//        tableView.reloadSections(IndexSet(integer: 1), with: .fade)
//
//        fetchPosts { newPosts in
//            self.posts.append(contentsOf: newPosts)
//            self.endReached = newPosts.count == 0
//            self.fetchingMore = false
//            UIView.performWithoutAnimation {
//                self.tableView.reloadData()
//                self.listenForNewPosts()
//            }
//        }
//
//
//    }
    
//    func getLastPhoto(completion: @escaping(_ key:String)->()){
//        let key = Auth.auth().currentUser?.uid
//        let ref = Database.database().reference().child("users/profile/\(key)").child("photoURL")
//        ref.observe(.value){ snapshot in
//            guard  let photoURL = snapshot.value as? String else {return}
//            completion(photoURL)
//        }
//    }
    
    
    
//    func getLastKey(completion: @escaping(_ key:String)->())   {
//        var key:String = ""
//        let ref = Database.database().reference().child("posts").queryLimited(toLast: 1)
//        ref.observe(.value){ snapshot in
//            for child in snapshot.children {
//                if let childSnapshot = child as? DataSnapshot{
//                       key = childSnapshot.key
//                    return completion(key)
//                }
//            }
//
//        }
//
//    }
//
//    func listenForNewPosts( ){
//        guard !fetchingMore else { return }
//
//        // Avoiding duplicate listeners
//        stopListeningForNewPosts()
//        getLastKey { (key) in
//            let firstPost = self.posts.first
//            let firstPostID = firstPost?.postID
//
//
//             if firstPostID != nil {
//                    if key != firstPostID {
//                        self.stopListeningForNewPosts()
//
//
//                        if firstPostID == self.lastUplaodedPostID {
//                            self.handleRefresh()
//                            self.lastUplaodedPostID = nil
//                        }else {
//                            self.toggleSeeNewPostsButton(hidden: false)
//                        }
//                    }
//            }
//        }



        
    }
    var postListenerHandle:UInt?

//    func listenForNewPostss() {
//
//        guard !fetchingMore else { return }
//
//        // Avoiding duplicate listeners
//        stopListeningForNewPosts()
////        print("snapshot")
//
//        let ref = Database.database().reference().child("posts").queryLimited(toLast: 1)
//
//        ref.observe(.value) { snapshot in
//            print(self.posts.first?.id)
//
//            if snapshot.key != self.posts.first?.id,
//                let data = snapshot.value as? [String:Any],
//                let post = Post.parse(snapshot.key, data) {
//
//
//                self.stopListeningForNewPosts()
//
//                if snapshot.key == self.lastUplaodedPostID {
//                    self.handleRefresh()
//                    self.lastUplaodedPostID = nil
//                } else {
//                    self.toggleSeeNewPostsButton(hidden: false)
//                }
//            }
//        }
//
//
//    }
    
//    @IBAction func messagesTapped(_ sender: Any) {
//        let messagesTableViewController = MessagesTableViewController()
//        navigationController?.pushViewController(messagesTableViewController, animated: true)
//    }
//
//
//    func stopListeningForNewPosts() {
//        if let handle = postListenerHandle {
//            newPostsQuery.removeObserver(withHandle: handle)
//            postListenerHandle = nil
//        }
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let newPostNavBar = segue.destination as? UINavigationController,
//            let newPostVC = newPostNavBar.viewControllers[0] as? NewPostViewController {
//
//            newPostVC.delegate = self
//        }
//    }
//}

extension HomeViewController:NewPostVCDelegate {
    func didUploadPost(withID id: String) {
       self.lastUplaodedPostID = id
    }
}
extension HomeViewController:NewEditVCDelegate {
    func didChangePhoto(withString url: String) {
        self.currentProfilePhoto = url

    }
    
 
}
