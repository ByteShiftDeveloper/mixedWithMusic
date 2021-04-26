//
//  NewMessageTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 4/20/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "NewMessageCell"

class NewMessageTableViewController: UITableViewController {
    
    
    var users = [User]()
    var messagesController: MessagesTableViewController?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        tableView.backgroundColor = UIColor(named: "DefaultBackgroundColor")
        // register cell
        tableView.register(NewMessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // removes separator views from unused rows
        tableView.tableFooterView = UIView(frame: .zero)
        
        fetchUser()
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewMessageCell
        cell.user = users[indexPath.row]
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatController(forUser: user)
        }
    }
    
    // MARK: - Handlers
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "New Message"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    
    func fetchUser(){
    
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            print(snapshot)
            
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let uid = snapshot.key
            
            let user = User(uid: uid, dictionary: dictionary)
            
            self.users.append(user)
            
            self.tableView.reloadData()
                
        }
    
    }

}
