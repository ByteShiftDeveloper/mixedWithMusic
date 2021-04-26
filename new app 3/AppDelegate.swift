//
//  AppDelegate.swift
//  new app 3
//
//  Created by William Hinson on 11/5/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import UserNotifications
import FirebaseMessaging
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var playerViewController : PlayerDetailController?
    var feedController : FeedController?
    var exploreController : ExploreController?
    var bottomAnchorConstraint : NSLayoutConstraint?
    var viewBottomAnchor : NSLayoutConstraint?
    var topAnchor : NSLayoutConstraint?
    var tabBar : UITabBar?
    var height : CGFloat?
    var miniPlayerInView = false

   
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        // Override point for customization after application launch.
        
        let authListener = Auth.auth().addStateDidChangeListener { auth, user in
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if user != nil {
                
                UserService.observeUserProfile(user!.uid) { userProfile in
                    UserService.currentUserProfile = userProfile
                    
                }
                
             
                
                
                //
                let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                self.tabBar = controller.tabBar

                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
          
            } else {
                
                UserService.currentUserProfile = nil
                // menu screen
                let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
            }
            
        }
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        attempToRegisterForNotifications(application: application)

        
        return true
    }
    
    
    func addPlayerView(song : SongPost? ){
        if let player = self.playerViewController{
            UIView.animate(withDuration: 0.3) {
                
            player.miniPlayerView.alpha = 0
            player.maximizedStackView.alpha = 1
                if let song = song {
                    player.song = song
                }
                
//            player.frame = CGRect(x: 0, y: 0, width: player.frame.width , height: player.playerHeight)
                self.bottomAnchorConstraint?.constant = 0
                self.topAnchor?.constant =  0//player.playerHeight
                player.topConstr = 0//player.miniPlayerViewY
            }
        }else{
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            
            playerViewController = PlayerDetailController.initFromNib()
            playerViewController?.song = song
            
            height = (tabBar?.frame.height ?? 0) + window.safeAreaInsets.bottom - 1
            
            playerViewController?.miniPlayerViewY = window.frame.height - (height ?? 0) - 64
            playerViewController?.playerHeight = window.frame.height
            UIView.animate(withDuration: 0.5) {
                
                window.addSubview(self.playerViewController!)
                self.playerViewController?.translatesAutoresizingMaskIntoConstraints = false
                
                self.topAnchor = self.playerViewController!.topAnchor.constraint(equalTo: window.topAnchor, constant: 0)
                self.topAnchor?.isActive = true
                self.playerViewController?.topConstr = 0//player.miniPlayerViewY
                
                self.bottomAnchorConstraint = self.playerViewController!.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: 0)

                self.bottomAnchorConstraint?.isActive = true
                
                let leadingCOns = self.playerViewController!.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 0)
                let trailingCons = self.playerViewController!.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: 0)
                leadingCOns.isActive = true
                trailingCons.isActive = true
            
             
            }
            playerViewController?.miniPlayerView.alpha = 0
            playerViewController?.maximizedStackView.alpha = 1

        }

    }
    
    func dismissPlayerView( ){
       
        if let player = self.playerViewController{
           
//            bottomAnchorConstraint?.isActive = true

            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

//                player.frame = CGRect(x: 0, y: player.miniPlayerViewY, width: player.frame.width, height: 64)

                self.bottomAnchorConstraint?.constant = -(self.height ?? 0)
                self.topAnchor?.constant =  player.miniPlayerViewY
                player.topConstr = player.miniPlayerViewY
                
//                player.layoutIfNeeded()
                player.maximizedStackView.alpha = 0
                player.miniPlayerView.alpha = 1
                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                window.layoutIfNeeded()
                
                

            })
            
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func attempToRegisterForNotifications(application: UIApplication) {
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (authorized, error) in
            if authorized {
                print("SUCCESSFULY REGISTERED FOR NOTIFICAITONS")
            }
        }
        
        application.registerForRemoteNotifications()
        
    }
    

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("REGISTERED FOR NOTIFICATIONS WITH DEVICE TOKEN", deviceToken)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("DEBUG: Registered with FCM token: ", fcmToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
