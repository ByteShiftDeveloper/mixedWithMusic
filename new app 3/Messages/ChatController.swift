//
//  ChatController.swift
//  new app 3
//
//  Created by William Hinson on 4/20/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation


private let chateReuseIdentifier = "ChatCell"



class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User?
    var messages = [Message]()
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var messagePost: Post?
    var posts = [Post]()
    
    
    
    let keyWindow = UIApplication.shared.connectedScenes
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows.first

    
    lazy var containerView: MessageInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
        let containerView = MessageInputAccesoryView(frame: frame)
//        containerView.layer.borderWidth = 0.5
        containerView.delegate = self
        return containerView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor(named: "BlackColor")
      
        
        collectionView.backgroundColor = UIColor(named: "DefaultBackgroundColor")
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: chateReuseIdentifier)
        collectionView.keyboardDismissMode = .interactive

        configureNavigationBar()
        configureKeyboardObservers()
        observeMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backgroundColor = UIColor(named: "DefaultBackgroundColor")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        player?.pause()
        playerLayer?.removeFromSuperlayer()
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var startingFrame: CGRect?
    var backGroundView: UIView?
    var startingImageView: UIImageView?
        
        func performZoomInForStartingImageView(startingImageView: UIImageView) {
            
            self.startingImageView = startingImageView
            self.startingImageView?.isHidden = true
            startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
            print(startingFrame)
            
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
    
    //MARK: -UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           var height: CGFloat = 100
        let postID = messages[indexPath.item].postID
        
        if postID != nil {
            Service.shared.fetchPost(withPostID: postID!) { (post) in
                height = self.estimateFrameForText(post.text).height + 80
            }
        }
             
        
             let message = messages[indexPath.item]
             if let messageText = message.messageText {
                 height = estimateFrameForText(messageText).height + 20
             } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
                 height = CGFloat(imageHeight / imageWidth * 200)
             }
             
             return CGSize(width: view.frame.width, height: height)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chateReuseIdentifier, for: indexPath) as! ChatCell
        cell.message = messages[indexPath.item]
        cell.delegate = self
        cell.chatController = self
        if messages[indexPath.item].postID != nil {
            configurePostMessage(cell: cell, message: messages[indexPath.item])
            
        }  else {
            configureMessage(cell: cell, message: messages[indexPath.item])
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postID = messages[indexPath.item].postID
        
        if postID != nil {
            Service.shared.fetchPost(withPostID: postID!) { (post) in
                let controller = SelectedPostController(post: post)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
    }
    
//    @objc func handleSend() {
//       uploadMessageToServer(withProperties: <#T##[String : AnyObject]#>)
//
//        messageTextField.text = nil
//
//    }
    
    @objc func handleInfoTapped() {

        let controller = NewProfileVC()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    @objc func handleKeyboardDidShow() {
        scrollToBottom()
    }
    
    
   func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    func configurePostMessage(cell: ChatCell, message: Message) {
           guard let currentUid = Auth.auth().currentUser?.uid else { return }
        var post = [Post]()
        
            Service.shared.fetchPost(withPostID: message.postID) { (posts) in
                let messageText = posts.text
                cell.bubbleWidthAnchor?.constant = self.estimateFrameForText(messageText).width + 32
                cell.frame.size.height = self.estimateFrameForText(messageText).height + 60
               cell.messageImageView.isHidden = true
               cell.textView.isHidden = true
                cell.sharedPostTextView.isHidden = false
                cell.sharedPostTextView.text = messageText
                cell.fullnameLabel.text = posts.user.fullname
                cell.timestampLabel.text = posts.createdAt.calenderTimeSinceNow()
                cell.playButton.isHidden = true
                cell.textView.textColor = .black
                cell.sharedPostProfileImageView.loadImage(with: posts.user.profileImageURL)
                cell.bubbleView.backgroundColor  = .white
                cell.bubbleView.layer.borderColor = UIColor.lightGray.cgColor
                cell.bubbleView.layer.borderWidth = 0.5
                
                if posts.user.isVerified != "" {
                    cell.verifiedMark.isHidden = false
                } else {
                    cell.verifiedMark.isHidden = true
                }
                
                
                
                
//                
//                cell.textView.leftAnchor.constraint(equalTo: cell.sharedPostProfileImageView.leftAnchor, constant: 8).isActive = true
//                cell.textView.topAnchor.constraint(equalTo: cell.sharedPostProfileImageView.topAnchor, constant: 8).isActive = true
//                cell.textView.rightAnchor.constraint(equalTo: cell.bubbleView.rightAnchor).isActive = true
//                cell.textView.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
                
            }
           
//           if let messageText = message.messageText {
//               cell.bubbleWidthAnchor?.constant = estimateFrameForText(messageText).width + 32
//               cell.frame.size.height = estimateFrameForText(messageText).height + 20
//               cell.messageImageView.isHidden = true
//               cell.textView.isHidden = false
//               cell.bubbleView.backgroundColor  = UIColor.rgb(red: 0, green: 137, blue: 249)
//           } else if let messageImageUrl = message.imageUrl {
//               cell.bubbleWidthAnchor?.constant = 200
//               cell.messageImageView.loadImage(with: messageImageUrl)
//               cell.messageImageView.isHidden = false
//               cell.textView.isHidden = true
//               cell.bubbleView.backgroundColor = .clear
//           }
//           else if message.postID != nil {
//            cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.messageText).width + 32
//            cell.frame.size.height = estimateFrameForText(message.messageText).height + 20
//                cell.messageImageView.isHidden = true
//                cell.textView.isHidden = false
//                cell.bubbleView.backgroundColor  = UIColor.rgb(red: 0, green: 137, blue: 249)
//           }
        
//            if message.postID != nil {
//                Service.shared.fetchPost(withPostID: message.postID) { (post) in
//                    print("Post text is  \(post.text)")
//                    self.posts.append(post)
//                    guard let messageText = post.text else { return }
//                    cell.bubbleWidthAnchor?.constant = self.estimateFrameForText(messageText).width + 32
//                    cell.frame.size.height = self.estimateFrameForText().height + 20
//                    cell.messageImageView.isHidden = true
//                    cell.textView.isHidden = false
//                    cell.bubbleView.backgroundColor  = UIColor.rgb(red: 0, green: 137, blue: 249)
//                }
//            }
           
           if message.fromId == currentUid {
               cell.bubbleViewRightAnchor?.isActive = true
               cell.bubbleViewLeftAnchor?.isActive = false
               cell.textView.textColor = .white
               cell.profileImageView.isHidden = true
           } else {
               cell.bubbleViewRightAnchor?.isActive = false
               cell.bubbleViewLeftAnchor?.isActive = true
               cell.bubbleView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
               cell.textView.textColor = .black
               cell.profileImageView.isHidden = false
           }
       }
    
    
    func configureMessage(cell: ChatCell, message: Message) {
           guard let currentUid = Auth.auth().currentUser?.uid else { return }
        cell.sharedPostProfileImageView.isHidden = true
           if let messageText = message.messageText {
               cell.bubbleWidthAnchor?.constant = estimateFrameForText(messageText).width + 32
               cell.frame.size.height = estimateFrameForText(messageText).height + 20
               cell.messageImageView.isHidden = true
               cell.textView.isHidden = false
            cell.sharedPostTextView.isHidden = true
            cell.timestampLabel.isHidden = true
            cell.fullnameLabel.isHidden = true
            cell.verifiedMark.isHidden = true
//            cell.bubbleView.setGradient(colorTop: .black, colorBottom: Colors.space)
            //                UIColor.rgb(red: 0, green: 137, blue: 249)
           } else if let messageImageUrl = message.imageUrl {
               cell.bubbleWidthAnchor?.constant = 200
               cell.messageImageView.loadImage(with: messageImageUrl)
               cell.messageImageView.isHidden = false
               cell.textView.isHidden = true
            cell.sharedPostTextView.isHidden = true
            cell.timestampLabel.isHidden = true
            cell.verifiedMark.isHidden = true
            cell.fullnameLabel.isHidden = true
               cell.bubbleView.backgroundColor = .clear
            cell.bubbleView.layer.borderWidth = 0
           }
//           else if message.postID != nil {
//            cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.messageText).width + 32
//            cell.frame.size.height = estimateFrameForText(message.messageText).height + 20
//                cell.messageImageView.isHidden = true
//                cell.textView.isHidden = false
//                cell.bubbleView.backgroundColor  = UIColor.rgb(red: 0, green: 137, blue: 249)
//           }
        
//            if message.postID != nil {
//                Service.shared.fetchPost(withPostID: message.postID) { (post) in
//                    print("Post text is  \(post.text)")
//                    self.posts.append(post)
//                    guard let messageText = post.text else { return }
//                    cell.bubbleWidthAnchor?.constant = self.estimateFrameForText(messageText).width + 32
//                    cell.frame.size.height = self.estimateFrameForText().height + 20
//                    cell.messageImageView.isHidden = true
//                    cell.textView.isHidden = false
//                    cell.bubbleView.backgroundColor  = UIColor.rgb(red: 0, green: 137, blue: 249)
//                }
//            }
      
           
           if message.videoUrl != nil {
               guard let videoUrlString = message.videoUrl else { return }
               guard let videoUrl = URL(string: videoUrlString) else { return }
               
               player = AVPlayer(url: videoUrl)
               cell.player = player
               
               playerLayer = AVPlayerLayer(player: player)
               cell.playerLayer = playerLayer
               
               cell.playButton.isHidden = false
           } else {
               cell.playButton.isHidden = true
           }
           
           if message.fromId == currentUid {
               cell.bubbleViewRightAnchor?.isActive = true
               cell.bubbleViewLeftAnchor?.isActive = false
               cell.textView.textColor = .white
               cell.profileImageView.isHidden = true
           } else {
               cell.bubbleViewRightAnchor?.isActive = false
               cell.bubbleViewLeftAnchor?.isActive = true
               cell.bubbleView.backgroundColor = .clear
               cell.bubbleView.layer.borderWidth = 0.25
               cell.bubbleView.layer.borderColor = UIColor(named: "BlackColor")?.cgColor
               cell.textView.textColor = UIColor(named: "BlackColor")
               cell.profileImageView.isHidden = false
           }
       }
    
    func configureNavigationBar() {
          guard let user = self.user else { return }
          
          navigationItem.title = user.fullname
          
          let infoButton = UIButton(type: .infoLight)
          infoButton.tintColor = UIColor(named: "BlackColor")
          infoButton.addTarget(self, action: #selector(handleInfoTapped), for: .touchUpInside)
          let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
          
          navigationItem.rightBarButtonItem = infoBarButtonItem
      }
    
    func configureKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    func scrollToBottom() {
          if messages.count > 0 {
              let indexPath = IndexPath(item: messages.count - 1, section: 0)
              collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
          }
      }
    
    
    
    func uploadMessageToServer(withProperties properties: [String: AnyObject]) {
          guard let currentUid = Auth.auth().currentUser?.uid else { return }
          guard let user = self.user else { return }
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
//            var notificationCount : Int = 0
//                notificationCount += 1
//                UNREAD_MESSAGES_REF.child(uid).updateChildValues(["unread": count])
          }
        
//        let unreadCountRef = UNREAD_MESSAGES_REF.child(uid).child("unread")
//        unreadCountRef.observeSingleEvent(of: .value) { (snapshot) in
//            var currentCount = snapshot.value as? Int ?? 0
//            currentCount += 1
//            unreadCountRef.setValue(currentCount)
//        }

        
//        UNREAD_MESSAGES_REF.child(uid).observeSingleEvent(of: .value) { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
//            guard let count = dictionary["unread"] as? Int else { return }
//            print("snapshot for message is \(snapshot)")
//            let value = count + 1
//            UNREAD_MESSAGES_REF.child(uid).updateChildValues(["unread": value])
//
//        }
          
        uploadMessageNotification(isImageMessage: false, isVideoMessage: false, isTextMessage: true, isPost: false)
      }
    
    func observeMessages() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let chatPartnerId = self.user?.uid else { return }
        
        USER_MESSAGES_REF.child(currentUid).child(chatPartnerId).observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            self.fetchMessage(withMessageId: messageId)
        }
    }
    
    func fetchMessage(withMessageId messageId: String) {
        MESSAGES_REF.child(messageId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            let message = Message(dictionary: dictionary)
            self.messages.append(message)
            
            DispatchQueue.main.async(execute: {
                self.collectionView?.reloadData()
                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
            })
            self.setMessageToRead(forMessageId: messageId, fromId: message.fromId)
        }
    }

    func uploadMessageNotification(isImageMessage: Bool, isVideoMessage: Bool, isTextMessage: Bool, isPost:Bool) {
          guard let fromId = Auth.auth().currentUser?.uid else { return }
          guard let toId = user?.uid else { return }
          var messageText: String!
          
          if isImageMessage {
              messageText = "Sent an image"
          } else if isVideoMessage {
              messageText = "Sent a video"
          } else if isTextMessage{
              messageText = containerView.messageInputTextView.text
          } else if isPost {
            messageText = "Shared a post"
          }
          
          let values = ["fromId": fromId,
                        "toId": toId,
                        "messageText": messageText] as [String : Any]
          
          USER_MESSAGE_NOTIFICATIONS_REF.child(toId).childByAutoId().updateChildValues(values)
      }
    func uploadImageToStorage(selectedImage image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
          let filename = NSUUID().uuidString
          guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
          
          // UPDATE: - Created constant for ref to work with Firebase 5
          let ref = STORAGE_MESSAGE_IMAGES_REF.child(filename)
          
          ref.putData(uploadData, metadata: nil) { (metadata, error) in
              if error != nil {
                  print("DEBUG: Unable to upload image to Firebase Storage")
                  return
              }
              
              ref.downloadURL(completion: { (url, error) in
                  guard let url = url else { return }
                  completion(url.absoluteString)
              })
          }
      }
    
    func sendMessage(withImageUrl imageUrl: String, image: UIImage) {
        let properties = ["imageUrl": imageUrl, "imageWidth": image.size.width as Any, "imageHeight": image.size.height as Any] as [String: AnyObject]
        
        self.uploadMessageToServer(withProperties: properties)
        self.uploadMessageNotification(isImageMessage: true, isVideoMessage: false, isTextMessage: false, isPost: false)
    }
    
    func compressVideo(inputURL: URL,
                       outputURL: URL,
                       handler:@escaping (_ exportSession: AVAssetExportSession?) -> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset,
                                                       presetName: AVAssetExportPresetMediumQuality) else {
                                                        handler(nil)
                                                        
                                                        return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously {
            handler(exportSession)
        }
        
    }
    
    func uploadVideoToStorage(url : URL, completionHandler : ((_ url : URL? , _ error : Error?) -> Void)? = nil) {
        
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
        compressVideo(inputURL: url, outputURL: compressedURL) { [weak self](session) in
            guard let session = session else {
                return
            }
            
            switch session.status {
            case .unknown:
                completionHandler!(nil,nil)
                break
            case .waiting:
                completionHandler!(nil,nil)
                break
            case .exporting:
                completionHandler!(nil,nil)
                break
            case .completed:
                guard let compressedData = try? Data(contentsOf: compressedURL) else {
                    return
                }
                let vidName = UUID()
//                let vidReference = self?.storageRef.child("Videos/\(vidName).mp4")
//
                let filename = "postUploads"
                let storageRef = Storage.storage().reference().child("postUploads/\(UUID()).mp4")
                let metadata = StorageMetadata()
//                metadata.contentType = "video/quicktime"
                
//                let vidReference = self?.storageRef.child("Videos/\(vidName).mp4")

                
               let uploadTask = storageRef.putData(compressedData, metadata: nil) { (metadata, error) in
                    guard let _ = metadata else {
                        completionHandler!(nil,error)
                        // Uh-oh, an error occurred!
                        return
                    }
                    
                    // You can also access to download URL after upload.
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            completionHandler!(nil,error)
                            // Uh-oh, an error occurred!
                            return
                        }
                        completionHandler!(downloadURL,error)
                    }
                    
                    print("File size after compression: \(Double(compressedData.count / 1048576)) mb")
                    
                }
                
                let url = url
                guard let thumbnailImage = self?.thumbnailImage(forFileUrl: url) else { return }
                let videoUrl = url.absoluteString
                
                self?.uploadImageToStorage(selectedImage: thumbnailImage, completion: { (imageUrl) in
                    let properties: [String: AnyObject] = ["imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "videoUrl": videoUrl as AnyObject, "imageUrl": imageUrl as AnyObject]
                    self?.uploadMessageToServer(withProperties: properties)
                    self?.uploadMessageNotification(isImageMessage: false, isVideoMessage: true, isTextMessage: false, isPost: false)
                })
                
                uploadTask.observe(.progress) { (snapshot) in
                    print(snapshot.progress?.completedUnitCount)
                    
                    
                }

                
                // UPDATE: - Created constant for ref to work with Firebase 5
                let ref = STORAGE_MESSAGE_VIDEO_REF.child(filename)
                
            default:
                completionHandler!(nil,nil)
                break
            }
            
        
        }
//        let filename = NSUUID().uuidString
                
//        let filename = "messageVideos"
//        let storageRef = Storage.storage().reference().child("postUploads/\(UUID())")
//        let metadata = StorageMetadata()
//        metadata.contentType = "video/quicktime"
//
//        let vidURL = NSData(contentsOf: url) as Data?
//        let uploadTask = storageRef.putData(vidURL!, metadata: metadata)

        
//        ref.putFile(from: url, metadata: nil) { (metadata, error) in
//            
//            if error != nil {
//                print("DEBUG: Failed to upload video to FIRStorage with error: ", error as Any)
//                return
//            }
//            
//            ref.downloadURL(completion: { (url, error) in
//                guard let url = url else { return }
//                guard let thumbnailImage = self.thumbnailImage(forFileUrl: url) else { return }
//                let videoUrl = url.absoluteString
//                
//                self.uploadImageToStorage(selectedImage: thumbnailImage, completion: { (imageUrl) in
//                    let properties: [String: AnyObject] = ["imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "videoUrl": videoUrl as AnyObject, "imageUrl": imageUrl as AnyObject]
//                    self.uploadMessageToServer(withProperties: properties)
//                    self.uploadMessageNotification(isImageMessage: false, isVideoMessage: true, isTextMessage: false)
//                })
//            })
//        }
    }

    
    func thumbnailImage(forFileUrl fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let time = CMTimeMake(value: 1, timescale: 60)
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let error {
            print("DEBUG: Exception error: ", error)
        }
        return nil
    }
    
    func setMessageToRead(forMessageId messageId: String, fromId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
           if fromId != Auth.auth().currentUser?.uid {
               MESSAGES_REF.child(messageId).child("read").setValue(true)
           }
      }
}

extension ChatController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoUrl = info[.mediaURL] as? URL {
            uploadVideoToStorage(url: videoUrl) { (url, err) in
                print("Successfully uploaded video to database")
            }
        } else if let selectedImage = info[.editedImage] as? UIImage {
            uploadImageToStorage(selectedImage: selectedImage) { (imageUrl) in
                self.sendMessage(withImageUrl: imageUrl, image: selectedImage)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ChatController: MessageInputAccesoryViewDelegate {
    
    func handleUploadMessage(message: String) {
        let properties = ["messageText": message] as [String: AnyObject]
        uploadMessageToServer(withProperties: properties)
        
        self.containerView.clearMessageTextView()
    }
    
    func handleSelectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension ChatController: ChatCellDelegate {
    
    func handleImageZoom(for cell: ChatCell) {
        print("Zooming")
    }
    
    func handlePlayVideo(for cell: ChatCell) {
        guard let player = self.player else { return }
        guard let playerLayer = self.playerLayer else { return }
        playerLayer.frame = cell.bubbleView.bounds
        cell.bubbleView.layer.addSublayer(playerLayer)
        
        cell.activityIndicatorView.startAnimating()
        player.play()
        cell.playButton.isHidden = true
    }
}
