//
//  Followers.swift
//  new app 3
//
//  Created by William Hinson on 7/2/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "FollowCell"

class Followers: UITableViewController, UISearchBarDelegate {
    
    var uid: String?
    var users = [User]()
    let searchBar = UISearchBar()

    var user: User? {
        didSet {
            
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(FollowCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        fetchFollowers()
        
//        configureSearchBar()
        
//        tableView.separatorColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Followers"
        navigationController?.navigationBar.prefersLargeTitles = false


//        statusBarUIView?.backgroundColor = .white
    }
//
    override func viewWillDisappear(_ animated: Bool) {
//        statusBarUIView?.backgroundColor = .clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    func configureSearchBar() {
         searchBar.sizeToFit()
         searchBar.delegate = self
         navigationItem.titleView = searchBar
         searchBar.barTintColor = .white
         searchBar.tintColor = .black
         searchBar.isTranslucent = false
       }
    
        
    //MARK: -TableView Functions
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 60
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FollowCell
        cell.user = users[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = users[indexPath.row] as? User else { return }
//        let controller = ProfileCollectionViewController(user: user)
        let controller = NewProfileVC()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }

    //MARK: -API Calls
     
     func fetchFollowers() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var ref: DatabaseReference!
        
        ref = USER_FOLLOWER_REF
        
        let ref2 = Database.database().reference().child("user-followers")
        
        ref2.child(uid).observe(.value) { snapshot in
            let userId = snapshot.key
            
            print("SUCCESSFULY FETCHED USERS")
//            print("This is the userId \(userId)")
            
            REF_USERS.child(userId).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String:Any] else { return }
                let user = User(uid: userId, dictionary: dictionary)
                self.users.append(user)
                self.tableView.reloadData()
            }
        }
     }
}

extension Followers: FollowCellDelegate {
    func handleEditProfileFollow(_ cell: FollowCell) {
        guard let user = cell.user else { return }
        if user.isCurrentUser {
//            let controller = EditProfileController(user: user)
//            controller.delegate = self
//            let nav = UINavigationController(rootViewController: controller)
//            nav.modalPresentationStyle = .fullScreen
//            present(nav, animated: true, completion: nil)
            return
        }
        if user.isFollowed {
            Service.shared.unfollowUser(uid: user.uid) { (err, ref) in
                user.isFollowed = false
                self.tableView.reloadData()
            }
        } else {
            Service.shared.followUser(uid: user.uid) { (ref, err) in
                user.isFollowed = true
                self.tableView.reloadData()
                NotificationService.shared.uploadNotification(type: .follow, post: nil, user: user)
            }
        }
    }
}

