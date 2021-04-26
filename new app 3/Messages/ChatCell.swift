//
//  ChatCell.swift
//  new app 3
//
//  Created by William Hinson on 4/20/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import Kingfisher

protocol ChatCellDelegate: class {
    func handlePlayVideo(for cell: ChatCell)
    func handleImageZoom(for cell: ChatCell)
}


class ChatCell: UICollectionViewCell {
    
    var bubbleWidthAnchor:NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var delegate: ChatCellDelegate?
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var chatController: ChatController?

    
    var message: Message? {
        
        didSet {
            
            guard let messageText = message?.messageText else { return }
            textView.text = messageText
            guard let charPartnerId = message?.getChatPartnerId() else { return }
            
            Database.fetchUser(with: charPartnerId) { (user) in
//                guard let profileImageURL = user.profileImageURL else { return }
                let profileURL = URL(string: user.profileImageURL)
                self.profileImageView.kf.setImage(with: profileURL)
            }
            
        }
    }
    
    
    var postMessage: Message? {
        didSet {
            
        }
    }
    
    let bubbleView: UIView = {
       let view  = UIView()
//        view.backgroundColor = UIColor.rgb(red: 0, green: 137, blue: 249)
        view.backgroundColor = UIColor(named: "MessageColor")
        view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 16
            view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
            return view
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "play.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePlayVideo), for: .touchUpInside)
        return button
    }()
    
    let textView: UITextView = {
       let tv = UITextView()
        tv.text = "Sample text for now"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.textColor = .black
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        return tv
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(handleImageZoom))
        imageTap.numberOfTouchesRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(imageTap)
        return iv
    }()
    
    let messageImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let sharedPostTextView: UITextView = {
       let tv = UITextView()
        tv.text = "Sample text for now"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.textColor = UIColor(named: "BlackColor")
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        return tv
    }()
    
    let sharedPostProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 30, height: 30)
        iv.layer.cornerRadius = 30 / 2
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Peter Parker"
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleNameLabelTap))
//        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .lightGray
        label.text = "15 minutes ago"
        return label
    }()
    
    let verifiedMark: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark.seal.fill")
        iv.tintColor = UIColor(named: "BlackColor")
        return iv
    }()
    
    let sharedPostContainerView: UIView = {
       let view = UIView()
        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
            addSubview(bubbleView)
            addSubview(textView)
            addSubview(profileImageView)
        addSubview(sharedPostTextView)
        
    
            
            bubbleView.addSubview(messageImageView)
            messageImageView.anchor(top: bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
            bubbleView.addSubview(sharedPostContainerView)
            sharedPostContainerView.anchor(top: bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            sharedPostContainerView.addSubview(sharedPostTextView)
        sharedPostContainerView.addSubview(sharedPostProfileImageView)
        sharedPostContainerView.addSubview(fullnameLabel)
        sharedPostContainerView.addSubview(timestampLabel)
        
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, timestampLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -15
        let stack = UIStackView(arrangedSubviews: [sharedPostProfileImageView, labelStack])
        stack.spacing = 12
        
//        bubbleView.addSubview(stack)
//        stack.anchor(top: bubbleView.topAnchor, left: bubbleView.leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        sharedPostContainerView.addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
            
            bubbleView.addSubview(playButton)
            playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
            playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
            playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            playButton.translatesAutoresizingMaskIntoConstraints = false
            
            bubbleView.addSubview(activityIndicatorView)
            activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            profileImageView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: -4, paddingRight: 0, width: 32, height: 32)
            profileImageView.layer.cornerRadius = 32 / 2
        
        bubbleView.addSubview(sharedPostProfileImageView)
        sharedPostProfileImageView.anchor(top: bubbleView.topAnchor, left: bubbleView.leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        bubbleView.addSubview(fullnameLabel)
        fullnameLabel.anchor(top: bubbleView.topAnchor, left: sharedPostProfileImageView.rightAnchor, paddingTop: 8, paddingLeft: 8)
        
        bubbleView.addSubview(verifiedMark)
        verifiedMark.anchor(top: bubbleView.topAnchor, left: fullnameLabel.rightAnchor, paddingTop: 10, paddingLeft: 8, width: 16, height: 14)
        
        bubbleView.addSubview(timestampLabel)
        timestampLabel.anchor(top: fullnameLabel.bottomAnchor, left: fullnameLabel.leftAnchor, paddingTop: 0)
        
            // bubble view right anchor
            bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
            bubbleViewRightAnchor?.isActive = true
            
            // bubble view left anchor
            bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
            bubbleViewLeftAnchor?.isActive = false
            
            // bubble view width and top anchor
            bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
            bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
            bubbleWidthAnchor?.isActive = true
            bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            
            // bubble view text view anchors
            textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 10).isActive = true
            textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
            textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
//        textView.anchor(left: bubbleView.leftAnchor, right: bubbleView.rightAnchor, paddingLeft: 8)
//        textView.centerY(inView: bubbleView)
        
        sharedPostTextView.leftAnchor.constraint(equalTo:  bubbleView.leftAnchor, constant: 8).isActive = true
        sharedPostTextView.topAnchor.constraint(equalTo: sharedPostProfileImageView.bottomAnchor, constant: 0).isActive = true
        sharedPostTextView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        sharedPostTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        player?.pause()
        activityIndicatorView.stopAnimating()
        playerLayer?.removeFromSuperlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePlayVideo() {
        delegate?.handlePlayVideo(for: self)
    }
    
    
    @objc func handleImageZoom(tapGesture: UITapGestureRecognizer) {
        delegate?.handleImageZoom(for: self)
        let imageView = tapGesture.view as? UIImageView
        self.chatController?.performZoomInForStartingImageView(startingImageView: imageView!)
    }
    
}
