//
//  LaunchScreenViewController.swift
//  new app 3
//
//  Created by William Hinson on 1/16/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit

class LaunchScreenViewController: UIViewController {
    
    let mwmImage = UIImageView(image: UIImage(named: "mwm logo for app")!)
    let splashView = UIView()
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        splashView.backgroundColor = UIColor.black
        view.addSubview(splashView)
        splashView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        mwmImage.contentMode = .scaleAspectFit
        splashView.addSubview(mwmImage)
        mwmImage.frame = CGRect(x: splashView.frame.midX - 50, y: splashView.frame.midY - 50, width: 100, height: 100)
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.scaleDownAnimation()
        }
    }
    
    func scaleDownAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.mwmImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
        }) { ( success ) in
            self.scaleUpAnimation()
            
        }
        
    }
    
    func scaleUpAnimation() {
        
        UIView.animate(withDuration: 0.35, delay: 0.1, options: .curveEaseIn, animations: {
            self.mwmImage.transform = CGAffineTransform(scaleX: 5, y: 5)
            
        }) { ( success ) in
            self.removeSplashScreen()
        }
    }
    
    func removeSplashScreen() {
        splashView.removeFromSuperview()
    }
}
