//
//  NotificationsController.swift
//  new app 3
//
//  Created by William Hinson on 5/29/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

private var reuseIdentifier = "NotificationsCell"


class NotificationsController: UITableViewController {
   
    private var notificaitons = [Notifications]() {
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
        self.tabBarController?.tabBar.items![3].badgeValue = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = self.navigationController?.navigationBar else { return }
               
        navBar.tintColor = UIColor(named: "BlackColor")
        navBar.barTintColor = UIColor(named: "DefaultBackgroundColor")

        navBar.isTranslucent = false
               
    }

    @objc func handleRefresh() {
        print("Refresh")
        fetchNotifications()
    }
    
    func configureUI() {
        view.backgroundColor = UIColor(named: "DefaultBackgroundColor")
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 70
        tableView.tableFooterView = UIView()
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func fetchNotifications() {
        refreshControl?.beginRefreshing()
        NotificationService.shared.fetchNotifications { notifications in
            self.refreshControl?.endRefreshing()
            self.notificaitons = notifications.sorted(by: { $0.timestampt > $1.timestampt})
            self.checkIfUserIsFollowed(notifications: notifications)
        }
    }
    
    func checkIfUserIsFollowed(notifications: [Notifications]) {
        for (index, notification) in notifications.enumerated() {
                if case .follow = notification.type {
                let user = notification.user
    
                Service.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                    self.notificaitons[index].user.isFollowed = isFollowed
                }
            }
        }
    }

}


extension NotificationsController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if notificaitons.count == 0 {
               self.tableView.setEmptyMessage("There are currently no new notificaitons")
            self.tableView.refreshControl?.endRefreshing()
           } else {
               self.tableView.restore()
           }
        return notificaitons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationsCell
        cell.notification = notificaitons[indexPath.row]
        cell.delegate = self
    return cell
    }
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notificaitons[indexPath.row]
        guard let postID = notification.postID else { return }
       // guard let gigID = notification.gigID else { return }
        Service.shared.fetchPost(withPostID: postID) { post in
            let controller = SelectedPostController(post: post)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension NotificationsController: NotificationCellDelegate {
    func epkTap(_ cell: NotificationsCell) {
        guard let user = cell.notification?.user else { return }
        let application = UIApplication.shared
        print("User who applied is \(user.fullname)")
        if user.epkURL == "" && user.epkPDF != ""{
            let controller = EPKpdfView()
            controller.document = user.epkPDF
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
            
        } else if user.epkURL != "" && user.epkPDF == "" {
            let webURL = URL(string: user.epkURL)!
            application.open(webURL)
        }
    }
    
    func handleProfileImageTapped(_ cell: NotificationsCell) {
        guard let user = cell.notification?.user else { return }
//        let controller = ProfileCollectionViewController(user: user)
        let controller = NewProfileVC()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func followTap(_ cell: NotificationsCell) {
        guard let user = cell.notification?.user else { return }
        if user.isFollowed {
            cell.followButton.backgroundColor = .white
            cell.followButton.setTitleColor(.black, for: .normal)
            cell.followButton.layer.borderColor = UIColor.black.cgColor
            Service.shared.unfollowUser(uid: user.uid) { (err, ref) in
                user.isFollowed = false
                self.tableView.reloadData()
            }
        } else {
            cell.followButton.backgroundColor = .black
            cell.followButton.setTitleColor(.white, for: .normal)
            Service.shared.followUser(uid: (user.uid)) { (ref, err) in
                user.isFollowed = true
                self.tableView.reloadData()
                NotificationService.shared.uploadNotification(type: .follow, user: user)
            }
        }
    }
}
