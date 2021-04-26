//
//  PostReplyController.swift
//  new app 3
//
//  Created by William Hinson on 5/20/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

class PostReplyController: UIViewController {
    
    private let user: User
    private let post: Post

  private lazy var actionButton: UIButton = {
      let button = UIButton(type: .system)
      button.backgroundColor = .black
      button.setTitle("Reply", for: .normal)
      button.titleLabel?.textAlignment = .center
      button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
      button.setTitleColor(.white, for: .normal)
      
      button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
      button.layer.cornerRadius = 32 / 2
      
      button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
      
      return button
  }()
  
  private let profileImageView: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFit
      iv.clipsToBounds = true
      iv.setDimensions(width: 48, height: 48)
      iv.layer.cornerRadius = 48 / 2
      iv.backgroundColor = .lightGray
      return iv
  }()
  
  private lazy var replyLabel: ActiveLabel = {
      let label = ActiveLabel()
      label.font = UIFont.systemFont(ofSize: 14)
      label.textColor = .lightGray
    label.mentionColor = Colors.activelabelblue
      label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
      return label
  }()
  
  private let replyText = InputTextView()
    
    init(user: User, post: Post) {
        self.user = user
        self.post = post
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMentionHandler()
//        configureMentionHandler()
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
        
    @objc func handleUploadTweet() {
        let postID = post.postID 
            guard let replyText = replyText.text else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let creationDate = Int(NSDate().timeIntervalSince1970)
    
            let values = ["text": replyText,
                          "timestampt": creationDate,
                          "likes": 0,
                          "reposts": 0,
                          "uid": uid] as [String : Any]
    
            Database.database().reference().child("post-comments").child(postID).childByAutoId().updateChildValues(values)
        
        NotificationService.shared.uploadNotification(type: .comment, post: post)
    
            self.dismiss(animated: true, completion: nil)
        }
    
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, replyText])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 16, paddingLeft: 16,
                     paddingRight: 16)
        
        
        profileImageView.loadImage(with: user.profileImageURL)
        
        replyLabel.text = "Replying to @\(post.user.username)"
        
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    func configureMentionHandler() {
        replyLabel.handleMentionTap { username in
            UserService.shared.fetchUserByUserName(withUsername: username) { user in
                let controller = ProfileCollectionViewController(user: user)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }



}
