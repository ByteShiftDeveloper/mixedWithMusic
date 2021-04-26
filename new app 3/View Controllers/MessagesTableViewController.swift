//
//  MessagesTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 4/6/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

private let cellid = "MessageCellTVC"


class MessagesTableViewController: UITableViewController {
    
    
      
        var messages = [Message]()
        var messagesDictionary = [String: Message]()
        
        // MARK: - Init
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            configureNavigationBar()
            
            tableView.register(MessageCellTVC.self, forCellReuseIdentifier: cellid)
            tableView.tableFooterView = UIView(frame: .zero)
            
            fetchMessages()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
//            tabBarController?.tabBar.isHidden = true
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
//            tabBarController?.tabBar.isHidden = false
        }
        
        // MARK: - UITableView
        
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let message = messages[indexPath.row]
            let chatPartnerId = message.getChatPartnerId()
            
            USER_MESSAGES_REF.child(uid).child(chatPartnerId).removeValue { (err, ref) in
                
                self.messages.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return messages.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! MessageCellTVC
            cell.delegate = self
            cell.message = messages[indexPath.row]
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let currentUID = Auth.auth().currentUser?.uid else { return }
            let message = messages[indexPath.row]
            let chatPartnerId = message.getChatPartnerId()
            let cell = tableView.cellForRow(at: indexPath) as! MessageCellTVC
            let read = message.read
            
//            if !read! {
//                UNREAD_MESSAGES_REF.child(currentUID).observeSingleEvent(of: .value) { (snapshot) in
//                    guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
//                    guard let count = dictionary["unread"] as? Int else { return }
//                    print("The total amount of unread messages is \(count)")
//                    let value = count  1
//                    if count >= 1 {
//                    UNREAD_MESSAGES_REF.child(currentUID).updateChildValues(["unread": value])
//                    } else if count == 0 {
//                        //do nothing
//                    }
//                }
//            } else if read! {
//                print("This item has been read")
//            }
            
            Database.fetchUser(with: chatPartnerId) { (user) in
                self.showChatController(forUser: user)
                cell.messageTextLabel.font = UIFont.systemFont(ofSize: 12)
            }
            
            print("This message is read\(String(describing: read))")
            print("Clicking on chat message, current uid is \(currentUID)")
        }
        
        // MARK: - Handlers
        
        @objc func handleNewMessage() {
            let newMessageController = NewMessageTableViewController()
            newMessageController.messagesController = self
            let navigationController = UINavigationController(rootViewController: newMessageController)
            self.present(navigationController, animated: true, completion: nil)
        }
        
        func showChatController(forUser user: User) {
            let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
            chatController.user = user
            navigationController?.pushViewController(chatController, animated: true)
        }
        
        func configureNavigationBar() {
            navigationItem.title = "Messages"
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
        }
        
        // MARK: - API
        
        func fetchMessages() {
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            
            self.messages.removeAll()
            self.messagesDictionary.removeAll()
            self.tableView.reloadData()
            
            USER_MESSAGES_REF.child(currentUid).observe(.childAdded) { (snapshot) in
                let uid = snapshot.key
                
                USER_MESSAGES_REF.child(currentUid).child(uid).observe(.childAdded, with: { (snapshot) in
                    let messageId = snapshot.key
                    self.fetchMessage(withMessageId: messageId)
                })
            }
        }
        
        func fetchMessage(withMessageId messageId: String) {
            
            MESSAGES_REF.child(messageId).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                
                let message = Message(dictionary: dictionary)
                let chatPartnerId = message.getChatPartnerId()
                self.messagesDictionary[chatPartnerId] = message
                self.messages = Array(self.messagesDictionary.values)
                
                self.messages.sort(by: { (message1, message2) -> Bool in
                    return message1.creationDate > message2.creationDate
                })
                
                self.tableView?.reloadData()
            }
        }
    }

    extension MessagesTableViewController: MessageCellDelegate {
        
        func configureUserData(for cell: MessageCellTVC) {
            guard let chatPartnerId = cell.message?.getChatPartnerId() else { return }
            
            Database.fetchUser(with: chatPartnerId) { (user) in
                print("DEBUG: User image url \(user.profileImageURL)")
                print("DEBUG: User name is \(user.fullname)")
                cell.profileImageView.loadImage(with: user.profileImageURL)
                cell.usernameLabel.text = user.fullname
            }
        }
}
