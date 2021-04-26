//
//  TabBarController.swift
//  new app 3
//
//  Created by William Hinson on 4/20/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let playerView = PlayerDetailController()
    
    

    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = user
            
//            guard let nav2 = viewControllers?[4] as? UINavigationController else { return }
//            guard let post = nav.viewControllers.first as? ProfileCollectionViewController else { return }
//            post.user = user

        }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.isUserInteractionEnabled = true
        return iv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let selectSong = HeaderViewTableViewController()
        selectSong.delegate = self
        TabBarController.playersDetailView.delegate = self
//        playerView.downChevronTapped((Any).self)
//        authenticateUser()
        self.delegate = self
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(minimizePlayerDetails), name: NSNotification.Name(rawValue: "minimize"), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(maximizePlayerDetails), name: NSNotification.Name(rawValue: "maximize"), object: nil)

    
        fetchUser()
//        
        setUpPlayerDetail()
        
        configureViewControllers()
        
//        perform(#selector(maximizePlayerDetails), with: nil, afterDelay: 1)
        
    }
    
    func configureViewControllers() {
        
                
        let feedVC = configureNavController(unselectedImage: UIImage(systemName: "house")!, selectedImage: UIImage(systemName: "house.fill")!, rootViewController: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let searchVC = configureNavController(unselectedImage: UIImage(systemName: "magnifyingglass")!, selectedImage:  UIImage(systemName: "magnifyingglass")!, rootViewController: ExploreController())
        
        let newpostVC = configurePostNavController(unselectedImage: (UIImage(named: "PostButton")?.withRenderingMode(.alwaysOriginal))!, selectedImage: (UIImage(named: "PostButton")?.withRenderingMode(.alwaysOriginal))!)
        
        
        let notificationsVC = configureNavController(unselectedImage: UIImage(systemName: "bell")!, selectedImage: UIImage(systemName: "bell.fill")!, rootViewController: NotificationsController())
        
//        let profileVC = configureNavController(unselectedImage: UIImage(systemName: "bell")!, selectedImage: UIImage(systemName: "bell.fill")!, rootViewController: ProfileCollectionViewController(user: user))
//        
        let profileController = configureNavController(unselectedImage: UIImage(named: "stage")  ?? UIImage(), selectedImage: UIImage(named: "stage") ?? UIImage(), rootViewController: GigsController())
        
        
        viewControllers = [feedVC, searchVC, newpostVC, notificationsVC, profileController]
        
        tabBar.tintColor = .black
        
        
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            let newPostVC = UploadPostController(user: user!)
            let navController = UINavigationController(rootViewController: newPostVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
            return false
        }
        
//        if index == 4 {
////            let newPostVC = ProfileCollectionViewController(user: user!)
//            return false
//        }
        
        return true
    }
    
    func configureNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        return navController
    }
    
    
    func configurePostNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        return navController
    }

    func authenticateUser() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: ViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configureViewControllers()
            fetchUser()
        }
    }
    

    @objc func minimizePlayerDetails() {
        print(1111)
        
        maximizeTopAnchorConstraint.isActive = false
        minimizeTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
        })
    }
    
    func maximizePlayerDetails() {
        minimizeTopAnchorConstraint.isActive = false
        maximizeTopAnchorConstraint.isActive = true
        maximizeTopAnchorConstraint.constant = 0
              
        bottomAnchorConstraint.constant = 0
                    
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                         
        self.view.layoutIfNeeded()
                  
        self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
                  
        TabBarController.self.playersDetailView.maximizedStackView.alpha = 1
        TabBarController.self.playersDetailView.miniPlayerView.alpha = 0
        })

    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func dismiss() {
        maximizeTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizeTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.tabBar.transform = .identity
            
            self.view.layoutIfNeeded()
            TabBarController.self.playersDetailView.maximizedStackView.alpha = 0
            TabBarController.self.playersDetailView.miniPlayerView.alpha = 1
        })
    }
    
    static let playersDetailView = PlayerDetailController.initFromNib()

    var maximizeTopAnchorConstraint: NSLayoutConstraint!
    var minimizeTopAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    
    fileprivate func setUpPlayerDetail() {
        print("setting up view")
        
        
//        view.addSubview(playersDetailView)
        view.insertSubview(TabBarController.playersDetailView, belowSubview: tabBar)

        TabBarController.playersDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizeTopAnchorConstraint = TabBarController.playersDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizeTopAnchorConstraint.isActive = true
        
        bottomAnchorConstraint = TabBarController.playersDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        bottomAnchorConstraint.isActive = true


        minimizeTopAnchorConstraint = TabBarController.playersDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minimizeTopAnchorConstraint.isActive = true
//
        TabBarController.playersDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        TabBarController.playersDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }
    
}
extension TabBarController : PlayerDetailDelegate{
    
    func handleMaximizie() {
        minimizeTopAnchorConstraint.isActive = false
        maximizeTopAnchorConstraint.isActive = true
        maximizeTopAnchorConstraint.constant = 0
        
        bottomAnchorConstraint.constant = 0
        
        self.tabBar.isHidden = true

               
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            

            TabBarController.self.playersDetailView.maximizedStackView.alpha = 1
            TabBarController.self.playersDetailView.miniPlayerView.alpha = 0
        })
    }
    
    func handleDismissal(){
        print("dismiss")
        maximizeTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizeTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.tabBar.transform = .identity
            
            self.tabBar.isHidden = false

            
            self.view.layoutIfNeeded()
            TabBarController.self.playersDetailView.maximizedStackView.alpha = 0
            TabBarController.self.playersDetailView.miniPlayerView.alpha = 1
        })
    }
}

extension TabBarController: SelectSongDelegate {
    func handleMaximize() {
        maximizeTopAnchorConstraint.isActive = true
        maximizeTopAnchorConstraint.constant = 0
        minimizeTopAnchorConstraint.isActive = false
                
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                          
        self.view.layoutIfNeeded()
            
            TabBarController.self.playersDetailView.maximizedStackView.alpha = 1
            TabBarController.self.playersDetailView.miniPlayerView.alpha = 0
        })
    }
}
