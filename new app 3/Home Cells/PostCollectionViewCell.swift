//
//  PostCollectionViewCell.swift
//  new app 3
//
//  Created by William Hinson on 5/6/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit



class PostCollectionViewCell: UICollectionViewCell {

       var delegate: ProfileFeedCellDelegate?
        
        @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
        @IBOutlet weak var usernameLabel: UILabel!
        
        @IBOutlet weak var unlikeButton: UIButton!
        
        @IBOutlet weak var profileImageView: UIImageView!
        
        @IBOutlet weak var subtitleLabel: UILabel!
        
        @IBOutlet weak var postTextLabel: UILabel!
        
        @IBOutlet weak var postImage: UIImageView!
        
        @IBOutlet weak var likeButton: UIButton!
        @IBOutlet weak var commentButton: UIButton!
        
        @IBOutlet weak var likeCountLabel: UILabel!
        @IBOutlet weak var shareButton: UIButton!
        var postID: String!
        
        var toggleState = 1
    
    
    var post: Post? {
        didSet { configure() }
    }
        

        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            
            commentButton.addTarget(self, action: #selector(handleCommentTap), for: .touchUpInside)
            
            likeButton.addTarget(self, action: #selector(handleLikeTap), for: .touchUpInside)
           
            profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
            profileImageView.clipsToBounds = true
            
        }
        
         @objc func handleCommentTap() {
             delegate?.handleCommentTapped(for: self)
         }
         
         @objc func handleLikeTap() {
             delegate?.handleLikeTapped(for: self)
         }
         
         @objc func handleShowLikes() {
             delegate?.handleShowLikes(for: self)
             
         }
         
         func configureLikeButton() {
             delegate?.handleConfigureLikeButton(for: self)
         }
         
         @objc func handleProfileImageTapped() {
             delegate?.handleProfileImageTap(for: self)
        }
        

//        override func setSelected(_ selected: Bool, animated: Bool) {
//            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
//        }
     
//        weak var post:Post?
        
        func set(post:Post) {
            self.post = post
            
            profileImageView.loadImage(with: post.user.profileImageURL)
                    
                    if post.picture != "" {
                        
                        postImage.loadImage(with: post.picture)
                        self.imageHeightConstraint.constant = 317
                    }
                    else {
            //            postImage?.isHidden = true
                        imageHeightConstraint.constant = 0

            //
                    }
                    
                usernameLabel.text = post.user.username
                postTextLabel.text = post.text
                subtitleLabel.text = post.createdAt.calenderTimeSinceNow()
                guard let likes = post.likes else { return }
                likeCountLabel.text = "\(likes)"
                configureLikeButton()
                let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
                likeTap.numberOfTouchesRequired = 1
                likeCountLabel.isUserInteractionEnabled = true
                likeCountLabel.addGestureRecognizer(likeTap)

                let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
                profileTap.numberOfTouchesRequired = 1
                profileImageView.isUserInteractionEnabled = true
                profileImageView.addGestureRecognizer(profileTap)
            

    }
    
    func configure() {
        guard let post = post else { return }
        profileImageView.loadImage(with: post.user.profileImageURL)
                
                if post.picture != "" {
                    
                    postImage.loadImage(with: post.picture)
                    self.imageHeightConstraint.constant = 317
                }
                else {
        //            postImage?.isHidden = true
                    imageHeightConstraint.constant = 0

        //
                }
                
            usernameLabel.text = post.user.username
            postTextLabel.text = post.text
            subtitleLabel.text = post.createdAt.calenderTimeSinceNow()
            guard let likes = post.likes else { return }
            likeCountLabel.text = "\(likes)"
            configureLikeButton()
            let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
            likeTap.numberOfTouchesRequired = 1
            likeCountLabel.isUserInteractionEnabled = true
            likeCountLabel.addGestureRecognizer(likeTap)

            let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
            profileTap.numberOfTouchesRequired = 1
            profileImageView.isUserInteractionEnabled = true
            profileImageView.addGestureRecognizer(profileTap)
        
    }
}
