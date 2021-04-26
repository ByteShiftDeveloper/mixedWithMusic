//
//  ProfileViewController.swift
//  new app 3
//
//  Created by William Hinson on 12/6/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController:UIViewController {
    
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var headerPic: UIImageView!
    @IBOutlet weak var whatDoYouConsiderYourself: UILabel!
    
    var databaseRef = Database.database().reference()
    
    var posts = [Post]()
    var fetchingMore = false
    var endReached = false
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var postsRef:DatabaseReference {
        let uid = Auth.auth().currentUser?.uid
        return Database.database().reference().child("posts")
    }
    
    var oldPostsQuery:DatabaseQuery {
        let lastPost = self.posts.last
        let lastPostID = lastPost?.postID
               var queryRef:DatabaseQuery
               if lastPost == nil {
                   queryRef = postsRef.queryOrdered(byChild: "timestamp")
               } else {
                print("last post\(lastPostID)")
                   let lastTimestamp = lastPost!.createdAt.timeIntervalSince1970 * 1000
                queryRef = postsRef.queryOrderedByKey().queryEnding(atValue: lastPostID)
               }
        return queryRef
    }
    
    var newPostsQuery:DatabaseQuery {
        let firstPost = posts.first
               var queryRef:DatabaseQuery
               if firstPost == nil {
                   queryRef = postsRef.queryOrdered(byChild: "timestamp")
               } else {
                   let firstTimestamp = firstPost!.createdAt.timeIntervalSince1970 * 1000
                   queryRef = postsRef.queryOrdered(byChild: "timestamp").queryStarting(atValue: firstTimestamp)
               }
        return queryRef
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
   
        guard let tabBar = self.tabBarController?.tabBar else { return }
                      
                      tabBar.tintColor = UIColor.black
                      tabBar.barTintColor = UIColor.white

        getFirebaseData()
        
        let cellNib =  UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        tableView.register(LoadingCell.self, forCellReuseIdentifier: "loadingCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.imageTapped(_:)))
        profilePic.addGestureRecognizer(pictureTap)
        profilePic.isUserInteractionEnabled = true
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.tintColor = .white
        
        
        
        if bio.text!.isEmpty {
            
            bio.isHidden = true
            
        } else {
            
            bio.isHidden = false
        }
        
        tableView.reloadData()
        
        beginBatchFetch()
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        getFirebaseData()
    }
    
    internal func setProfilePic(imageView:UIImageView,imageToSet:UIImage) {
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
    }
    
    internal func setHeaderPic(imageView2:UIImageView,imageToSet2:UIImage) {
        imageView2.layer.masksToBounds = true
        imageView2.image = imageToSet2
    }
    
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    
       func getFirebaseData(){
           
           guard let uid = Auth.auth().currentUser?.uid else { return }
           self.databaseRef.child("users/profile").child(uid).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
               let dict = snapshot.value as? [String:Any]
               self.fullNameLabel.text = dict!["username"] as? String
               self.whatDoYouConsiderYourself.text = dict!["What do you consider yourself?"] as? String
            self.bio.text = dict!["bio"] as? String
               
               if(dict!["photoURL"] != nil) {
               
               let databaseProfilePic = dict!["photoURL"] as! String
               
                   if let data = NSData(contentsOf: NSURL(string: databaseProfilePic)! as URL) {
                    
                       self.setProfilePic(imageView:self.profilePic,imageToSet:UIImage(data: data as Data)!)
                   }
               }
               
               if(dict!["headerURL"] != nil) {

                   let databaseHeaderPic = dict!["headerURL"] as! String

                   if let data2 = NSData(contentsOf: NSURL(string:databaseHeaderPic)! as URL) {
                       
                       self.setHeaderPic(imageView2: self.headerPic, imageToSet2: UIImage(data: data2 as Data)!)

                   }
               }
           }
           
       }
    
    func fetchPosts(completion: @escaping(_ posts:[Post])->()) {
           
            let ref = Database.database().reference().child("posts")
            oldPostsQuery.queryLimited(toLast: 20).observeSingleEvent(of: .value, with: { snapshot in
            
                var tempPosts = [Post]()
                
                let lastPost = self.posts.last
    //            print("last post\(lastPost)" )
    //            self.lastPost = self.posts.last
                print("posts count\(self.posts.count)")
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                        let data = childSnapshot.value as? [String:Any],
                        let post = Post.parse(childSnapshot.key, data),
                        childSnapshot.key != lastPost?.postID {
                        

                        tempPosts.insert(post, at: 0)
                   }
    //                let photoUrl = UserService.currentUserProfile?.photoURL
    //                self.lastProfilePhoto = photoUrl!.absoluteString
    //                self.checkForPhotoChanges{ abc in
    //                self.lastProfilePhoto = abc
    //                }
                }
                return completion(tempPosts)
                
            })
        }
//
//    @IBAction func showsComponents(_ sender: Any) {
//
//        if((sender as AnyObject).selectedSegmentIndex == 0) {
//            UIView.animate(withDuration: 0.5, animations: {
//
//                self.mediaContainer.alpha = 1
//                self.postsContainer.alpha = 0
//            })
//        } else if((sender as AnyObject).selectedSegmentIndex == 1) {
//            UIView.animate(withDuration: 0.5, animations: {
//
//                self.postsContainer.alpha = 1
//                self.mediaContainer.alpha = 0
//            })
//        }
//    }
    
    func beginBatchFetch() {
        fetchingMore = true
        //fetch post
        tableView.reloadSections(IndexSet(integer: 1), with: .fade)

        fetchPosts { newPosts in
            self.posts.append(contentsOf: newPosts)
            self.endReached = newPosts.count == 0
            self.fetchingMore = false
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
                self.listenForNewPosts()
            }
        }
        
        
    }
    
    
    func getLastKey(completion: @escaping(_ key:String)->())   {
        var key:String = ""
        let ref = Database.database().reference().child("posts").queryLimited(toLast: 1)
        ref.observe(.value){ snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot{
                       key = childSnapshot.key
                    return completion(key)
                }
            }
            
        }
        
    }
    
    func listenForNewPosts( ){
        guard !fetchingMore else { return }
        
        // Avoiding duplicate listeners
        stopListeningForNewPosts()
        getLastKey { (key) in
            let firstPost = self.posts.first
            let firstPostID = firstPost?.postID
            

             if firstPostID != nil {
                    if key != firstPostID {
                        self.stopListeningForNewPosts()
                
//
//                        if firstPostID == self.lastUplaodedPostID {
//                            self.handleRefresh()
//                            self.lastUplaodedPostID = nil
//                        }else {
//                            self.toggleSeeNewPostsButton(hidden: false)
//                        }
                    }
            }
        }



        
    }
    
    var postListenerHandle:UInt?
    
    func stopListeningForNewPosts() {
        if let handle = postListenerHandle {
            newPostsQuery.removeObserver(withHandle: handle)
            postListenerHandle = nil
        }
    }
    
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return posts.count
        } else {
            return fetchingMore ? 1 : 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
                cell.set(post: self.posts[indexPath.row])
                
//                cell.commentButton.addTarget(self, action: #selector(HomeViewController.goToReply), for: .touchUpInside)
//                cell.likeButton.addTarget(self, action: #selector(HomeViewController.likePost), for: .touchUpInside)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
                cell.spinner.startAnimating()
                return cell
            }
    }
}
