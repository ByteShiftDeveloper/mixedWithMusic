//
//  Following.swift
//  new app 3
//
//  Created by William Hinson on 7/2/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "FollowCell"

class Following: UITableViewController, UISearchBarDelegate {
    
    var user: User? {
        didSet {
            
        }
    }
    
    var uid: String?
    var users = [User]()
    let searchBar = UISearchBar()
    
    var statusBarUIView: UIView? {

       if #available(iOS 13.0, *) {
           let tag = 3848245

           let keyWindow = UIApplication.shared.connectedScenes
               .map({$0 as? UIWindowScene})
               .compactMap({$0})
               .first?.windows.first

           if let statusBar = keyWindow?.viewWithTag(tag) {
               return statusBar
           } else {
               let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
               let statusBarView = UIView(frame: height)
               statusBarView.tag = tag
               statusBarView.layer.zPosition = 999999

               keyWindow?.addSubview(statusBarView)
               return statusBarView
           }

       } else {

           if responds(to: Selector(("statusBar"))) {
               return value(forKey: "statusBar") as? UIView
           }
       }
       return nil
     }

        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(FollowCell.self, forCellReuseIdentifier: reuseIdentifier)
//        navigationItem.title = "Following"
//        navigationController?.navigationBar.tintColor = .black
//        navigationController?.navigationBar.backgroundColor = .white
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

//        statusBarUIView?.backgroundColor = .white
        fetchFollowing()
//        configureSearchBar()
//        tableView.separatorColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Following"
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
        searchBar.frame = CGRect(x: 0, y: 0, width: (navigationController?.view.bounds.size.width)!, height: 64)
         searchBar.barTintColor = .white
         searchBar.tintColor = .black
         searchBar.isTranslucent = false
        view.addSubview(searchBar)
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
    
    func fetchFollowing() {
        var ref: DatabaseReference!
        
        ref = USER_FOLLOWING_REF
        
        ref.child(user!.uid).observe(.childAdded) { snapshot in
            let userId = snapshot.key
            
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
