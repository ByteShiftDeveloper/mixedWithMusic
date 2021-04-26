//
//  MainTabBarController.swift
//  new app 3
//
//  Created by William Hinson on 4/19/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupPlayerViewController()
        
//        perform(#selector(maximizePlayerDetail), with: nil, afterDelay: 1)
    }
    
    @objc func minimizePlayerDetail() {
        
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    
    @objc func maximizePlayerDetail() {
        
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        minimizedTopAnchorConstraint.isActive = false
               
               UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                   self.view.layoutIfNeeded()
               })
        
    }
    
    let playerDetailView = PlayerDetailController.initFromNib()

    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    
    func setupPlayerViewController() {
        
        print("Setting Up PlayerViewController")
        
        
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        
        
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        
        maximizedTopAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minimizedTopAnchorConstraint.isActive = true
        
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }


}

