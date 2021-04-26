//
//  MessagesListTableViewCell.swift
//  new app 3
//
//  Created by William Hinson on 4/6/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

class MessagesListTableViewCell: UITableViewCell {
    
//    var delegate: MessageCellDelegate?
//    
//    var message: Message? {
//        
//        didSet{
//            
//            guard let message = self.message else { return }
//            guard let messageText = message.messageText else { return }
//            guard let read = message.read else { return }
//            
//            if !read && message.fromId != Auth.auth().currentUser?.uid {
//                           messageTextPreview.font = UIFont.boldSystemFont(ofSize: 16)
//                       } else {
//                           messageTextPreview.font = UIFont.systemFont(ofSize: 16)
//                       }
//            
//            messageTextPreview.text = messageText
//            configureTimestamp(forMessage: message)
////            delegate?.configureUserData(for: self)
//            
//            configureUserData()
//
//        }
//    }
//
//    @IBOutlet weak var profilePic: UIImageView!
//    @IBOutlet weak var username: UILabel!
//    @IBOutlet weak var messageTextPreview: UILabel!
//    @IBOutlet weak var time: UILabel!
//    
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//    func configureTimestamp(forMessage message: Message) {
//        if let seconds = message.creationDate {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "h:mm a"
//            time.text = dateFormatter.string(from: seconds)
//        }
//    }
//
//    
//    func configureUserData() {
//
//        guard let chatPartnerId = message?.getChatPartnerId() else { return }
//
//        Database.fetchUser(with: chatPartnerId) { (user) in
//            print("testing")
//            print(user)
//            self.profilePic.loadImage(with: user.profileImageURL)
//            self.profilePic.layer.cornerRadius = self.profilePic.bounds.height / 2
//            self.profilePic.clipsToBounds = true
//            self.profilePic.contentMode = .scaleAspectFit
//            self.username.text = user.username
//        }
//
//    }
}


