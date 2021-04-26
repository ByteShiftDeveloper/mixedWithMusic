//
//  UsersProfileTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 4/27/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

class UsersProfileTableViewController: UITableViewController, UserProfileHeaderDelegate {
    
        
        
        @IBOutlet weak var trackImage: UIImageView!
        @IBOutlet weak var bio: UILabel!
        @IBOutlet weak var fullNameLabel: UILabel!
        @IBOutlet weak var profilePic: UIImageView!
        @IBOutlet weak var headerPic: UIImageView!
        @IBOutlet weak var whatDoYouConsiderYourself: UILabel!
    @IBOutlet weak var followUnfollowButton: UIButton!
        
        private let tableHeaderViewHeight: CGFloat = 320.0
        private let tableHeaderViewCutAway: CGFloat = 0.1
        
        var headerView: ProfileHeader!
        var headerMaskLayer: CAShapeLayer!
        var segmentedControl = UISegmentedControl()
        var isSegmentInNavBar : Bool = false
        var databaseRef = Database.database().reference()
        var user: User?
        var userToLoadFromSearchVC: User?
    



        
        override func viewDidLoad() {
            super.viewDidLoad()
            
//            setUserInformation()
            
            
            
            fetchCurrentUserData()
            
//            followUnfollowButton.setTitle("Follow", for: .normal)
//                    followUnfollowButton.layer.borderWidth = 2.0
//                    followUnfollowButton.layer.borderColor = Colors.blackColor.cgColor
//            followUnfollowButton.backgroundColor = .white
//            followUnfollowButton.setTitleColor(.black, for: .normal)
            
            
            
            let cellNib =  UINib(nibName: "PostTableViewCell", bundle: nil)
                   tableView.register(cellNib, forCellReuseIdentifier: "postCell")
                   tableView.register(LoadingCell.self, forCellReuseIdentifier: "loadingCell")
            
            self.automaticallyAdjustsScrollViewInsets = false
            
            tableView.estimatedSectionHeaderHeight = 40.0
    //        navigationController?.navigationBar.tintColor = .white
    //                    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    //                    navigationController?.navigationBar.shadowImage = UIImage()
            

            headerView = tableView.tableHeaderView as! ProfileHeader
//                        headerView.imageView = trackImage
                        tableView.tableHeaderView = nil
                        tableView.addSubview(headerView)
            
                        tableView.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
                        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 64)
            
                        //cut away header view
                        headerMaskLayer = CAShapeLayer()
                        headerMaskLayer.fillColor = UIColor.black.cgColor
                        headerView.layer.mask = headerMaskLayer
            
                        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutAway/2
                        tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
                        tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
            
            
            updateHeaderView()
            
            
        }
    

//    @IBAction func followUnfollowTapped(_ sender: Any) {
//        print("tapped")
//
//        if followUnfollowButton.titleLabel?.text == "Follow" {
//                    followUnfollowButton.setTitle("Following", for: .normal)
//                    followUnfollowButton.backgroundColor = .black
//            followUnfollowButton.setTitleColor(.white, for: .normal)
//            guard let user = self.user else { return }
//            user.follow()
//                } else {
//                    followUnfollowButton.setTitle("Follow", for: .normal)
//                    followUnfollowButton.layer.borderWidth = 2.0
//                    followUnfollowButton.layer.borderColor = Colors.blackColor.cgColor
//            followUnfollowButton.backgroundColor = .white
//            followUnfollowButton.setTitleColor(.black, for: .normal)
//            guard let user = self.user else { return }
//            user.unfollow()
//                }
//
//
//    }
    

//    func followUnfollow() {
//
//        guard let user = self.user else { return }
//
//        if followUnfollowButton.titleLabel?.text == "Follow" {
//            followUnfollowButton.setTitle("Following", for: .normal)
////            followUnfollowButton.backgroundColor = .black
//            user.follow()
//        } else {
//            followUnfollowButton.setTitle("Follow", for: .normal)
//            followUnfollowButton.layer.borderWidth = 2.0
//            followUnfollowButton.layer.borderColor = Colors.blackColor.cgColor
//
//            user.unfollow()
//        }
//
//    }
    
    
    func handleEditFollowTapped(for header: ProfileHeader) {
        
        guard let user = header.user else { return }
        
        if header.followUnfollowButton.titleLabel?.text == "Follow" {
            
            header.followUnfollowButton.setTitle("Following", for: .normal)
            header.followUnfollowButton.setTitleColor(.white, for: .normal)
            header.followUnfollowButton.backgroundColor = .black
//            user.follow()
        } else {
            header.followUnfollowButton.setTitle("Follow", for: .normal)
            header.followUnfollowButton.setTitleColor(.black, for: .normal)
            header.followUnfollowButton.layer.borderWidth = 2.0
            header.followUnfollowButton.layer.borderColor = Colors.blackColor.cgColor
        }
        
    }
    
    
    func setUserInformation() {
        
        profilePic.loadImage(with: (userToLoadFromSearchVC?.profileImageURL)!)
        profilePic.layer.cornerRadius = profilePic.bounds.height / 2
        profilePic.clipsToBounds = true
        headerPic.loadImage(with: (userToLoadFromSearchVC?.headerImageURL)!)
        bio.text = userToLoadFromSearchVC?.bio
        fullNameLabel.text = userToLoadFromSearchVC?.username
        whatDoYouConsiderYourself.text = userToLoadFromSearchVC?.artistBand
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func updateHeaderView() {
          let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutAway/2
          var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: tableHeaderViewHeight)
          
          if tableView.contentOffset.y < -effectiveHeight {
              headerRect.origin.y = tableView.contentOffset.y
              headerRect.size.height = -tableView.contentOffset.y + tableHeaderViewCutAway/2
          }
          
          headerView.frame = headerRect
          
          let path = UIBezierPath()
          path.move(to: CGPoint(x: 0, y:0))
          path.addLine(to: CGPoint(x: headerRect.width, y: 0))
          path.addLine(to: CGPoint(x: headerRect.width, y: headerRect.height))
          path.addLine(to: CGPoint(x: 0, y: headerRect.height - tableHeaderViewCutAway))
          
          headerMaskLayer?.path = path.cgPath
      }
    

        
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.tableView.decelerationRate = UIScrollView.DecelerationRate.fast
      }
      
      override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
          return UITableView.automaticDimension
      }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        if let searchVcUser = self.userToLoadFromSearchVC {
            headerView.user = userToLoadFromSearchVC
        }
        let v = UIView()
        v.backgroundColor = .white
        segmentedControl = UISegmentedControl(frame: CGRect(x: 0, y:-15, width: tableView.frame.width, height: 30))
        segmentedControl.insertSegment(withTitle: "One", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Two", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Three", at: 2, animated: false)
        segmentedControl.tintColor = .white
        v.addSubview(segmentedControl)
        //            tableView.estimatedSectionHeaderHeight = 40.0
        
        return v
        
    }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          100
          
      }
      
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
          return cell
      }
    
    func fetchCurrentUserData() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let uid = snapshot.key
            
            let user = User(uid: uid, dictionary: dictionary)
        }
    }


}

extension UsersProfileTableViewController {

 override func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
     var offset = scrollView.contentOffset.y / 150
     if offset > -0.5 {
         offset = 1
         self.navigationController?.navigationBar.tintColor = UIColor(hue: 1, saturation: offset, brightness: 1, alpha: 1)
         self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
     } else {
         self.navigationController?.navigationBar.tintColor = UIColor(hue: 1, saturation: offset, brightness: 1, alpha: 1)
         self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
     }
     
     

     let offsetY = scrollView.contentOffset.y + tableHeaderViewHeight
     updateHeaderView()
     
     let contentHeight = scrollView.contentSize.height
     
     
     let segmentView = UIView()
     segmentView.tag = 10
     
     segmentedControl.backgroundColor = .white


     
     let window = UIApplication.shared.keyWindow
     let topPadding = window?.safeAreaInsets.top
     let navHeight = self.navigationController?.navigationBar.frame.height
     
    if offsetY + topPadding! + navHeight! >= headerView.frame.height{
         if !isSegmentInNavBar{
             segmentedControl.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)!, width: tableView.frame.width, height: 30)
             segmentView.addSubview(segmentedControl)
             self.navigationController?.navigationBar.addSubview(segmentView)

             isSegmentInNavBar = true
             
         }
     }
     else{
         
         if isSegmentInNavBar{
             tableView.reloadSections( [0], with: .automatic)
             let subviews = self.navigationController?.navigationBar.subviews
             for subview in subviews!{
                 if subview.tag == 10{
                     subview.removeFromSuperview()
                 }
             }
             isSegmentInNavBar = false

         }
         
     }

 }
    
}
