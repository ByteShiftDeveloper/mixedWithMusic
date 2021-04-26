//
//  ShareSheetLaunch.swift
//  new app 3
//
//  Created by William Hinson on 10/21/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Foundation
import Firebase

private let reuseIdentifier2 = "ShareMainCVC"
private let headerIdentifier = "headerIdentifier"
private let footerIdentifier = "footerIdentifier"


class ShareSheetLaunch: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var user: User
    private let post: Post
    private var window: UIWindow?
    private var collectionViewHeight: CGFloat?
    var nav: FeedController!
    let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.alwaysBounceVertical = false
        return cv
    }()
    
    init(user: User, post: Post) {
        self.user = user
        self.post = post
        super.init()
        configureCV()
    }
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        return view
    }()

    
    func configureCV() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 10
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ShareMainCVC.self, forCellWithReuseIdentifier: reuseIdentifier2)
        collectionView.register(ShareHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(ShareFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
    }
    
    private lazy var footerView: UIView = {
        let view = UIView()
                
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor(left: view.leftAnchor, right: view.rightAnchor,
                            paddingLeft: 12, paddingRight: 12)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50 / 2
        
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(collectionView)
        let height = CGFloat(1 * 100) + 170
        collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 1
            self.collectionView.frame.origin.y -= height
//            self.showCollectionView(true)
        }
    }
    
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            self.collectionView.frame.origin.y += 300
        }
    }
    
    func showCollectionView(_ shouldShow: Bool) {
        guard let window = window else { return }
        guard let height = collectionViewHeight else { return }
        let y = shouldShow ? window.frame.height - height : window.frame.height
        collectionView.frame.origin.y = y
    }
    
    func showChatController(forUser user: User) {
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        chatController.containerView.messageInputTextView.text = post.postID
        chatController.containerView.messageInputTextView.placeholderLabel.isHidden = true
        print("Shared post is \(post.postID)")
        nav.navigationController?.pushViewController(chatController, animated: true)
        handleDismissal()
    }
    
   
    
    //MARK: -CollectionViewDelegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as! ShareMainCVC
//        cell.song = songs[indexPath.row]
        cell.del = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
  
            return CGSize(width: (window?.frame.width)!, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ShareHeader
            return header
            
        case UICollectionView.elementKindSectionFooter:
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath)
//            footer.delegate = self
            footer.addSubview(sendButton)
            sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            sendButton.anchor(left: footer.leftAnchor, right: footer.rightAnchor,
                                paddingLeft: 12, paddingRight: 12)
            sendButton.centerY(inView: footer)
            sendButton.layer.cornerRadius = 50 / 2
        return footer
        default:
            print("Break")
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
               return CGSize(width: (window?.frame.width)!, height: 30)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: (window?.frame.width)!, height: 100)
    }
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.backgroundColor = .systemGroupedBackground
        button.isEnabled = false
        button.addTarget(self, action: #selector(messageUpload), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: -API Calls
    func uploadMessageToServer(withProperties properties: [String: AnyObject]) {
          guard let currentUid = Auth.auth().currentUser?.uid else { return }
            let user = self.user
          let creationDate = Int(NSDate().timeIntervalSince1970)

          // UPDATE: - Safely unwrapped uid to work with Firebase 5
          let uid = user.uid

          var values: [String: AnyObject] = ["toId": user.uid as AnyObject, "fromId": currentUid as AnyObject, "creationDate": creationDate as AnyObject, "read": false as AnyObject]

          properties.forEach({values[$0] = $1})
          
          let messageRef = MESSAGES_REF.childByAutoId()
          
          // UPDATE: - Safely unwrapped messageKey to work with Firebase 5
          guard let messageKey = messageRef.key else { return }
          
          messageRef.updateChildValues(values) { (err, ref) in
              USER_MESSAGES_REF.child(currentUid).child(uid).updateChildValues([messageKey: 1])
              USER_MESSAGES_REF.child(uid).child(currentUid).updateChildValues([messageKey: 1])
          }
          
        uploadMessageNotification(isImageMessage: false, isVideoMessage: false, isTextMessage: false, isPost: true)
      }
    func uploadMessageNotification(isImageMessage: Bool, isVideoMessage: Bool, isTextMessage: Bool, isPost:Bool) {
          guard let fromId = Auth.auth().currentUser?.uid else { return }
        let toId = self.user.uid
        var messageText: String!
          
          if isImageMessage {
              messageText = "Sent an image"
          } else if isVideoMessage {
              messageText = "Sent a video"
          } else if isTextMessage{
//              messageText = containerView.messageInputTextView.text
          } else if isPost {
            messageText = "Shared a post"
          }
          
          let values = ["fromId": fromId,
                        "toId": toId,
                        "messageText": messageText] as [String : Any]
          
          USER_MESSAGE_NOTIFICATIONS_REF.child(toId).childByAutoId().updateChildValues(values)
      }
    
    func handleUploadMessage(message: String) {
        let properties = ["postID": message] as [String: AnyObject]
        uploadMessageToServer(withProperties: properties)
        handleDismissal()
        
//        self.containerView.clearMessageTextView()
    }
    
    @objc func messageUpload() {
        handleUploadMessage(message: post.postID)
    }
    
}

//MARK: -ShareFooter Delegate

extension ShareSheetLaunch: ShareFooterDelegate {
    func handleDismiss(_ footer: ShareFooter) {
        handleDismissal()
    }
}
