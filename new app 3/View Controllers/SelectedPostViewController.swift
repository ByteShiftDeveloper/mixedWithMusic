//
//  SelectedPostViewController.swift
//  new app 3
//
//  Created by William Hinson on 2/28/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class SelectedPostViewController: UIViewController {

    @IBOutlet weak var userPIc: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    
    var postID: String!
    
    
    var post:Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//                        self.imageHeightConstraint.constant = 317

                    }
                }
                else {
        //            postImage?.isHidden = true
//                    imageHeightConstraint.constant = 0

        //
                }
        
        
        
        guard let tabBar = self.tabBarController?.tabBar else { return }
                      
                      tabBar.tintColor = UIColor.black
                      tabBar.barTintColor = UIColor.white
        
        
//        loadInfo()

        // Do any additional setup after loading the view.
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        guard let tabBar = self.tabBarController?.tabBar else { return }
//
//        navigationController?.navigationBar.tintColor = UIColor.black
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        guard let tabBar = self.tabBarController?.tabBar else { return }
//
//        navigationController?.navigationBar.tintColor = UIColor.black
//    }
    

    
//
//    func loadInfo(){
//
//        usernameLabel.text = post?.author.fullname
//        postText.text = post?.text
//        timestampLabel.text = post?.createdAt.calenderTimeSinceNow()
//
//
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
//                imageHeightConstraint.constant = 0

    //
            }
            
        usernameLabel.text = post.user.username
            postText.text = post.text
            timestampLabel.text = post.createdAt.calenderTimeSinceNow()
        }
    
}
