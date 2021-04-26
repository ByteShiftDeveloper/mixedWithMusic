//
//  CommentCell.swift
//  new app 3
//
//  Created by William Hinson on 5/20/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol CommentDelegate: class {
    func handleProfileImageTapped(_ cell: CommentCell)
    func handleCommentTap(_ cell: CommentCell)
    func handleLikeTap(_ cell: CommentCell)
}

class CommentCell: UICollectionViewCell {
    
    var post: Post? {
        didSet { configureUI() }
    }
    
    weak var delegate: CommentDelegate?
    
     private lazy var profileImageView: UIImageView = {
               let iv = UIImageView()
               iv.contentMode = .scaleAspectFill
               iv.clipsToBounds = true
               iv.setDimensions(width: 45, height: 45)
               iv.layer.cornerRadius = 45 / 2
               iv.backgroundColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
               return iv
           }()
           
           
           private let fullnameLabel: UILabel = {
               let label = UILabel()
               label.font = UIFont.boldSystemFont(ofSize: 16)
               label.text = "Peter Parker"
            label.textColor = UIColor(named: "BlackColor")
               return label
           }()
           
           private let timestampLabel: UILabel = {
               let label = UILabel()
               label.font = UIFont.systemFont(ofSize: 14)
               label.textColor = .lightGray
               label.text = "15 minutes ago"
               return label
           }()
        
        private let postTextLabel: UILabel = {
           let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.numberOfLines = 0
            label.text = "Some random type of text"
            label.textColor = UIColor(named: "BlackColor")
            return label
        }()
        
        private let postPicture: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
    //        iv.setHeight(height: 317)
            iv.backgroundColor = .lightGray
            return iv
        }()
        
        private lazy var optionsButton: UIButton = {
            let button = UIButton(type: .system)
            button.tintColor = .lightGray
            button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            button.setDimensions(width: 20, height: 10)
            button.addTarget(self, action: #selector(handleActionSheet), for: .touchUpInside)
            return button
        }()
        
        private lazy var statsView: UIView = {
           let view = UIView()
            
            let divider1 = UIView()
            divider1.backgroundColor = .systemGroupedBackground
            view.addSubview(divider1)
            divider1.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 8, height: 1.0)
            
            let stack = UIStackView(arrangedSubviews: [likesLabel, repostLabel])
            stack.axis = .horizontal
            stack.spacing = 12
            
            view.addSubview(stack)
            stack.centerY(inView: view)
            stack.anchor(left: view.leftAnchor, paddingLeft: 16)
            
            let divider2 = UIView()
            divider2.backgroundColor = .systemGroupedBackground
            view.addSubview(divider2)
            divider2.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 8, height: 1.0)
            
            return view
        }()
        

        
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .lightGray
        label.text = "1"
        return label
    }()
    
    private lazy var commentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .lightGray
        label.text = "1"
        return label
    }()
    
    private lazy var repostLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.boldSystemFont(ofSize: 10)
           label.textColor = .lightGray
           label.text = "1"
           return label
       }()
        
        private lazy var commentButton: UIButton = {
               let button = UIButton(type: .system)
                    button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
                    button.tintColor = .lightGray
                    button.setDimensions(width: 18, height: 16)
                    button.addTarget(self, action: #selector(handleCommentTap), for: .touchUpInside)
                    return button
        }()
        
        private lazy var repostButton: UIButton = {
                let button = UIButton(type: .system)
                    button.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
                    button.tintColor = .lightGray
                    button.setDimensions(width: 22, height: 16)
                    button.addTarget(self, action: #selector(handleRepostTap), for: .touchUpInside)
                    return button
        }()
        
        lazy var likeButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "heart"), for: .normal)
            button.tintColor = .lightGray
            button.setDimensions(width: 18, height: 16)
            button.addTarget(self, action: #selector(handleLikeTap), for: .touchUpInside)
            return button
        }()
        
        private lazy var shareButton: UIButton = {
                let button = UIButton(type: .system)
                    button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
                    button.tintColor = .lightGray
                    button.setDimensions(width: 18, height: 16)
                    button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
                    return button
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
//            let labelStack = UIStackView(arrangedSubviews: [fullnameLabel])
//            labelStack.axis = .vertical
//            labelStack.spacing = -15
//            let stack = UIStackView(arrangedSubviews: [profileImageView, fullnameLabel])
//            fullnameLabel.anchor(top: profileImageView.topAnchor)
//            stack.spacing = 12
//
//
//            addSubview(stack)
//            stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
//
//            addSubview(postTextLabel)
//            postTextLabel.anchor(top: stack.bottomAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: -10, paddingLeft: 12, paddingRight: 16)
            
            addSubview(profileImageView)
            profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
            
            addSubview(fullnameLabel)
            fullnameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, paddingLeft: 12)
            
            addSubview(postTextLabel)
            postTextLabel.anchor(top: fullnameLabel.bottomAnchor, left: profileImageView.rightAnchor, paddingTop: 0, paddingLeft: 12)
            
//            addSubview(postPicture)
//            postPicture.anchor(top: postTextLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, width: frame.width, height: 317)
            
//            addSubview(optionsButton)
//            optionsButton.centerY(inView: stack)
//            optionsButton.anchor(right: rightAnchor, paddingRight: 16)
//
//            addSubview(statsView)
//            statsView.anchor(top: postPicture.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, height: 40)
            
//            let buttonStack = UIStackView(arrangedSubviews: [likeButton, commentButton, repostButton, shareButton])
//            buttonStack.spacing = 72
//
//            addSubview(buttonStack)
//            buttonStack.centerX(inView: self)
//            buttonStack.anchor(bottom: bottomAnchor, paddingBottom: 8)
            
            addSubview(likeButton)
            likeButton.anchor(right: self.rightAnchor, paddingRight: 16)
            likeButton.centerY(inView: postTextLabel)
            likeButton.addTarget(self, action: #selector(handleLikeTap), for: .touchUpInside)
            
//            addSubview(likesLabel)
//            likesLabel.anchor(left: likeButton.rightAnchor, bottom: bottomAnchor , paddingLeft: 1, paddingBottom: 11)
            
//            addSubview(commentsLabel)
//            commentsLabel.anchor(left: commentButton.rightAnchor, bottom: bottomAnchor , paddingLeft: 1, paddingBottom: 11)
//
//            addSubview(repostLabel)
//            repostLabel.anchor(left: repostButton.rightAnchor, bottom: bottomAnchor , paddingLeft: 1, paddingBottom: 11)

            
//            let underlineView = UIView()
//            underlineView.backgroundColor = .systemGroupedBackground
//            addSubview(underlineView)
//            underlineView.anchor(left: leftAnchor, bottom: bottomAnchor,
//                                 right: rightAnchor, height: 1)

        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func createButton(withImageName imageName: String) -> UIButton {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "heart"), for: .normal)
            button.tintColor = .darkGray
            button.setDimensions(width: 20, height: 20)
            return button
        }
        
       @objc func handleCommentTap() {
        delegate?.handleCommentTap(self)
         }
         
         @objc func handleLikeTap() {
            delegate?.handleLikeTap(self)
         }
         
         @objc func handleShowLikes() {
             
         }
         
         func configureLikeButton() {
         }
         
         @objc func handleProfileImageTapped() {
            delegate?.handleProfileImageTapped(self)
        }
    
        @objc func handleShareTapped() {
        
        }
    
        @objc func handleActionSheet() {
        
        }
    
    @objc func handleRepostTap() {
        
    }
    
    
    func configureUI() {
        
    guard let post = post else { return }
        profileImageView.loadImage(with: post.user.profileImageURL)
                
//                if post.picture != "" {
//
//                    postPicture.loadImage(with: post.picture)
//                    postPicture.setHeight(height: 317)
//                } else {
//                    postPicture.setHeight(height: 0)
//                }
        
            fullnameLabel.text = post.user.fullname
            postTextLabel.text = post.text
            timestampLabel.text = post.createdAt.calenderTimeSinceNow()
        if post.didLike == false {
            likeButton.tintColor = .black
            likeButton.setImage(UIImage(named: "heart_unfilled"), for: .normal)
        } else if post.didLike == true {
            likeButton.tintColor = .red
            likeButton.setImage(UIImage(named: "heart"), for: .normal)
        }
//            guard let likes = post.likes else { return }
//            likeCountLabel.text = "\(likes)"
//            configureLikeButton()
//            let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleShowLikes))
//            likeTap.numberOfTouchesRequired = 1
//            likeCountLabel.isUserInteractionEnabled = true
//            likeCountLabel.addGestureRecognizer(likeTap)
//
//            let profileTap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
//            profileTap.numberOfTouchesRequired = 1
//            profileImageView.isUserInteractionEnabled = true
//            profileImageView.addGestureRecognizer(profileTap)
        
    }
}
