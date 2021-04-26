//
//  MessageCellTVC.swift
//  new app 3
//
//  Created by William Hinson on 9/9/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

var unreadCount: Int = 0

class MessageCellTVC: UITableViewCell {
    
    // MARK: - Properties
    
    var delegate: MessageCellDelegate?
    
    var message: Message? {
        
        didSet {
            guard let message = self.message else { return }
            guard let messageText = message.messageText else { return }
            guard let read = message.read else { return }
            
            if !read && message.fromId != Auth.auth().currentUser?.uid {
                messageLabel.font = UIFont.boldSystemFont(ofSize: 14)
                messageLabel.textColor = UIColor(named: "BlackColor")
                unreadCount += 1
            } else {
                messageLabel.font = UIFont.systemFont(ofSize: 14)
                messageLabel.textColor = .lightGray
                unreadCount = 0
            }
            
            
            messageLabel.text = messageText
            configureTimestamp(forMessage: message)
            delegate?.configureUserData(for: self)
            configureUserData()
        }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "2h"
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Someone's name"
        label.textColor = UIColor(named: "BlackColor")
        return label
    }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(named: "BlackColor")
        return label
    }()
    
    let fullnameLabel: UILabel = {
       let label = UILabel()
        label.text = "Someone's name"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(named: "BlackColor")
        return label
    }()
    
    let messageLabel: UILabel = {
       let label = UILabel()
        label.text = "Here is a random message to test how this looks"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    let timestamp: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "2h"
        return label
    }()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print("The count for this is \(unreadCount)")
        
        selectionStyle = .none
    
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(fullnameLabel)
        fullnameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, paddingTop: 4, paddingLeft: 8)
        
        addSubview(timestamp)
        timestamp.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)
        
        addSubview(messageLabel)
        messageLabel.anchor(top: fullnameLabel.bottomAnchor, left: profileImageView.rightAnchor, right: timestamp.rightAnchor,  paddingTop: 6, paddingLeft: 8)
        

//        addSubview(usernameLabel)
//        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        addSubview(messageTextLabel)
//        messageTextLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        addSubview(timestampLabel)
//        timestampLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    func configureTimestamp(forMessage message: Message) {
        if let seconds = message.creationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            timestamp.text = dateFormatter.string(from: seconds)
        }
    }
    
    func configureUserData() {

           guard let chatPartnerId = message?.getChatPartnerId() else { return }

           Database.fetchUser(with: chatPartnerId) { (user) in
               print("testing")
               print(user)
               self.profileImageView.loadImage(with: user.profileImageURL)
               self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.height / 2
               self.profileImageView.clipsToBounds = true
               self.profileImageView.contentMode = .scaleAspectFill
               self.fullnameLabel.text = user.fullname
        }
    }
}
