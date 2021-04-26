//
//  ApplyToGigController.swift
//  new app 3
//
//  Created by William Hinson on 3/4/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit
import TwitterProfile


class ApplyToGigController : UIViewController, UIScrollViewDelegate, TPDataSource, TPProgressDelegate {
    
    var headerVC: HeaderView3?
    let refresh = UIRefreshControl()

    var profileCVC : ProfileCollectionView2?
    
    var user: User?
    
    var gigs: Gigs?
    var footerCell : GigApplyFooterButton?

    let keyWindow = UIApplication.shared.connectedScenes
               .map({$0 as? UIWindowScene})
               .compactMap({$0})
               .first?.windows.first
    
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
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.frame = CGRect(x: 20, y: 40, width: 30, height: 50)

        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //implement data source to configure tp controller with header and bottom child viewControllers
        //observe header scroll progress with TPProgressDelegate
        self.tp_configure(with: self, delegate: self)
        self.view.addSubview(backButton)
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        view.showsHorizontalScrollIndicator = false
        fetchUserStats()
        checkifUserApplied()
//        checkUserIsFollowed()
        view.backgroundColor = .white
     
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadChanges(_:)), name: Notification.Name("UserChanges"), object: nil)
        

    }
    
    var startingFrame: CGRect?
    var backGroundView: UIView?
    var startingImageView: UIImageView?
    
    @objc func reloadChanges(_ notification : Notification){
        let notObj = notification.userInfo! as NSDictionary
        let user = notObj["user"] as? User
       // self.user = user
        self.headerVC?.user = user
        self.headerVC?.configure()
        
    }
    
    func fetchUserStats() {
        Service.shared.fetchUserStats(uid: user!.uid) { stats in
            self.user?.stats = stats
            self.headerVC?.configure()
        }
    }
    
    func checkifUserApplied() {
//        guard let gig = gigs else { return }
//        Service.shared.checkIfUserAppled(gig) { didApply in
//            guard didApply == true else { return }
//                gig.didApply = true
//            self.footerCell?.uploadButton.setTitle("Applied!", for: .normal)
//            
//        }
    }
    
//    func checkUserIsFollowed() {
//        Service.shared.checkIfUserIsFollowed(uid: user!.uid) { isFollowed in
//            self.user?.isFollowed = isFollowed
//            if isFollowed == true {
//                self.headerVC?.btnFollow.backgroundColor = .black
//                self.headerVC?.btnFollow.setTitleColor(.white, for: .normal)
//                self.headerVC?.btnFollow.setTitle("Following", for: .normal)
//
//            } else if isFollowed == false {
//                self.headerVC?.btnFollow.backgroundColor = .white
//                self.headerVC?.btnFollow.setTitleColor(.black, for: .normal)
//                self.headerVC?.btnFollow.layer.borderColor = UIColor.black.cgColor
//                self.headerVC?.btnFollow.setTitle("Follow", for: .normal)
//            }
//        }
//    }
    
    
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        print(startingFrame)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleImageDismiss)))
        
        if let keywindow = keyWindow {
            
            backGroundView = UIView(frame: keywindow.frame)
            backGroundView?.backgroundColor = UIColor.black
            backGroundView?.alpha = 0
            keywindow.addSubview(backGroundView!)
            keyWindow?.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.backGroundView?.alpha = 1
                let height = self.startingFrame!.height / self.startingFrame!.width * keywindow.frame.width
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keywindow.frame.width, height: height)
                zoomingImageView.center = keywindow.center
            }, completion: { (Bool) in
//                zoomOutImageView.removeFromSuperview()
            })
        }
    }
    
   @objc func handleImageDismiss(gesture: UIPanGestureRecognizer) {
    if let zoomOutImageView = gesture.view    {
    if gesture.state == .changed {
        let translation = gesture.translation(in: zoomOutImageView)
        zoomOutImageView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: zoomOutImageView)
            let velocity = gesture.velocity(in: zoomOutImageView)
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.transform = .identity
            
                if translation.y > 400 || velocity.y > 200 {
                    zoomOutImageView.removeFromSuperview()
                    self.backGroundView?.alpha = 0
                    self.startingImageView?.isHidden = false
                    }
                })
            }
        }
    }
    
    @objc func handleDismiss(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(false, animated: false)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusBarUIView?.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.isHidden = false
        statusBarUIView?.isHidden = false

    }
    
   
    
//    @objc func handleRefreshControl() {
//        print("refreshing")
//        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//            self.fetchUserStats()
//            self.profileCVC?.fetchPost()
//            self.profileCVC?.fetchSingle()
//            self.profileCVC?.fetchAlbums()
//            self.profileCVC?.fetchLikedPosts()
//            self.refresh.endRefreshing()
//        }
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //MARK: TPDataSource
    func headerViewController() -> UIViewController {

        headerVC = HeaderView3()
        headerVC?.user = user
        headerVC?.gigs = gigs
        headerVC?.profileVC = self
        return headerVC!
    }
    
    var bottomVC: XLPagerTabStripExampleViewController2!
    func bottomViewController() -> UIViewController & PagerAwareProtocol {
        bottomVC = XLPagerTabStripExampleViewController2()
        bottomVC?.gigs = gigs

        return bottomVC
    }

    //stop scrolling header at this point
    func minHeaderHeight() -> CGFloat {
        return (topInset + 44)
    }
    
    //MARK: TPProgressDelegate
    func tp_scrollView(_ scrollView: UIScrollView, didUpdate progress: CGFloat) {
        headerVC?.update(with: progress, minHeaderHeight: minHeaderHeight())
    }
    
    func tp_scrollViewDidLoad(_ scrollView: UIScrollView) {
        
        refresh.tintColor = .white
//        refresh.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        let refreshView = UIView(frame: CGRect(x: 0, y: 44, width: 0, height: 0))
        scrollView.addSubview(refreshView)
        refreshView.addSubview(refresh)
    }
}
