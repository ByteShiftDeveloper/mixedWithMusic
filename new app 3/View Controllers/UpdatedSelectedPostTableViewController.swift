//
//  UpdatedSelectedPostTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 4/2/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

class UpdatedSelectedPostTableViewController: UITableViewController {
    
    var comments = [Comment]()
    
    @IBOutlet weak var userPIc: UIImageView!
     @IBOutlet weak var usernameLabel: UILabel!
     @IBOutlet weak var timestampLabel: UILabel!
     @IBOutlet weak var postText: UILabel!
     @IBOutlet weak var postImage: UIImageView!
     @IBOutlet weak var likeButton: UIButton!
     @IBOutlet weak var commentButton: UIButton!
     @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var showLikeButton: UIButton!
     
     @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
     
     
     var postID: String!
     
     
     var post:Post?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(postID)
        
        fetchComments()
        
        guard let likes = post?.likes else { return }
        
        showLikeButton.setTitle("\(likes) likes", for: .normal)
        
          navigationController?.navigationBar.tintColor = UIColor.black

                
                userPIc.layer.cornerRadius = userPIc.bounds.height / 2
                       userPIc.clipsToBounds = true
                
        usernameLabel.text = post?.user.username
                postText.text = post?.text
                timestampLabel.text = post?.createdAt.calenderTimeSinceNow()
                
        userPIc.loadImage(with: post!.user.profileImageURL)
                        if post!.picture != "" {
                            ImageService.getImage(withURL:URL (string:post!.picture)!) { image in
                                self.postImage.image = image
                                self.imageHeightConstraint.constant = 317

                            }
                        }
                        else {
                //            postImage?.isHidden = true
                            imageHeightConstraint.constant = 0

                //
                        }
                
                
                
                guard let tabBar = self.tabBarController?.tabBar else { return }
                              
                              tabBar.tintColor = UIColor.black
                              tabBar.barTintColor = UIColor.white
    }
    
    @IBAction func showWhoLikesPost(_ sender: Any) {
        let showLikesController = ShowLikesTableViewController()
        showLikesController.navigationItem.title = "Liked by"
        navigationController?.pushViewController(showLikesController, animated: true)
        
    }
    
        func set(post:Post) {
                self.post = post
                
            userPIc.loadImage(with: post.user.profileImageURL)
            
                if post.picture != "" {
                    ImageService.getImage(withURL:URL (string:post.picture)!) { image in
                        self.postImage.image = image
    //                    self.imageHeightConstraint.constant = 317

                    }
                }
                else {
        //            postImage?.isHidden = true
                    imageHeightConstraint.constant = 0

        //
                }
            
                
            usernameLabel.text = post.user.username
                postText.text = post.text
                timestampLabel.text = post.createdAt.calenderTimeSinceNow()
            }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPostCommentTableViewCell", for: indexPath) as! SelectPostCommentTableViewCell
        
        return cell
    }
    
    
    func fetchComments() {
        
        guard let postID = self.postID else { return }
        
        print(postID)
        
        Database.database().reference().child("comments").child(postID).observe(.childAdded) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            Database.fetchUser(with: uid) { (user) in
                
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                print("User that commented is \(comment.user?.username)")
                self.tableView.reloadData()
            
            }
        
        }
        
    }


}
