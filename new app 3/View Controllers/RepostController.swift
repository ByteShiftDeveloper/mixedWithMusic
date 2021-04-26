//
//  RepostController.swift
//  new app 3
//
//  Created by William Hinson on 8/24/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

class RepostController: UIViewController {
    
    private let user: User
    let post: Post

  private lazy var actionButton: UIButton = {
      let button = UIButton(type: .system)
      button.backgroundColor = .black
      button.setTitle("Repost", for: .normal)
      button.titleLabel?.textAlignment = .center
      button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
      button.setTitleColor(.white, for: .normal)
      
      button.frame = CGRect(x: 0, y: 0, width: 72, height: 32)
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
    
    lazy var repostView: UIView = {
       let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.25
        view.layer.cornerRadius = 3
        view.setDimensions(width: 100, height: 100)
    
        
        var profileImageView: UIImageView = {
               let iv = UIImageView()
               iv.contentMode = .scaleAspectFit
               iv.clipsToBounds = true
               iv.setDimensions(width: 40, height: 40)
               iv.layer.cornerRadius = 40 / 2
               iv.backgroundColor = .lightGray
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
//        iv.addGestureRecognizer(tap)
//        iv.isUserInteractionEnabled = true
               return iv
           }()
        
        let fullnameLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont.boldSystemFont(ofSize: 16)
                label.text = "Peter Parker"
//                let tap = UITapGestureRecognizer(target: self, action: #selector(handleNameLabelTap))
//                label.addGestureRecognizer(tap)
//                label.isUserInteractionEnabled = true
                    return label
            }()
        

        let timestampLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .lightGray
            label.text = "15 minutes ago"
            return label
        }()
        
        let postTextLabel: ActiveLabel = {
            let label = ActiveLabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = "This shit is crazy"
            label.numberOfLines = 0
            label.textColor = .black
            label.mentionColor = Colors.activelabelblue
            label.hashtagColor = Colors.activelabelblue
            return label
        }()
        
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, timestampLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -10
        let stack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        stack.spacing = 8
        
        view.addSubview(stack)
        stack.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(postTextLabel)
        postTextLabel.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
        
        profileImageView.loadImage(with: post.user.profileImageURL)
        fullnameLabel.text = post.user.fullname
        postTextLabel.text = post.text
        timestampLabel.text = post.createdAt.calenderTimeSinceNow()

        
        return view
    }()
  
  private let replyText = PostInputText()
    
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
//        let postID = post.postID
            guard let replyText = replyText.text else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let creationDate = Int(NSDate().timeIntervalSince1970)
    
            let values = ["text": replyText,
                          "timestampt": creationDate,
                          "likes": 0,
//                          "repostedPost": postID,
                          "uid": uid] as [String : Any]
    
        
//        NotificationService.shared.uploadNotification(type: .comment, post: post)
            
                let ref = POSTS_REF.childByAutoId()
                ref.updateChildValues(values) { (err, ref) in
                    guard let postID = ref.key else { return }
                    let repostedPostID = self.post.postID
                    USER_POSTS.child(uid).updateChildValues([postID: 1])
                    REPOSTED_POST.child(postID).updateChildValues([repostedPostID: 1])
                    
                }
        
        
    
            self.dismiss(animated: true, completion: nil)
        }
    
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, replyText])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 16, paddingLeft: 16,
                     paddingRight: 16)
        
        view.addSubview(repostView)
        repostView.anchor(top: imageCaptionStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingRight: 20)
        
        
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
