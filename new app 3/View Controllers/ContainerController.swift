//
//  ContainerController.swift
//  new app 3
//
//  Created by William Hinson on 11/7/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeViewController()
    }
    
    //MARK: - Handlers
    
    func configureHomeViewController() {
        let homeController = HomeViewController ()
        let controller = UINavigationController(rootViewController: homeController)
        
        view.addSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)
    }
    func configureMenuController() {
        
    }
}
