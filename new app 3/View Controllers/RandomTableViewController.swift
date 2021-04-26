//
//  RandomTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 4/11/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import UIKit
import Firebase

class RandomTableViewController: UITableViewController {
    
    private let profileFilter = ProfileFilterView()
    
    
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var headerPic: UIImageView!
    @IBOutlet weak var whatDoYouConsiderYourself: UILabel!
    
    private let tableHeaderViewHeight: CGFloat = 320.0
    private let tableHeaderViewCutAway: CGFloat = 0.1
    
    var headerView: ProfileHeader!
    var headerMaskLayer: CAShapeLayer!
    var segmentedControl = UISegmentedControl()
    var isSegmentInNavBar : Bool = false
    var databaseRef = Database.database().reference()
    var user: User?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchCurrentUserData()
        getFirebaseData()
        
        let cellNib =  UINib(nibName: "PostTableViewCell", bundle: nil)
               tableView.register(cellNib, forCellReuseIdentifier: "postCell")
               tableView.register(LoadingCell.self, forCellReuseIdentifier: "loadingCell")
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableView.estimatedSectionHeaderHeight = 40.0
//        navigationController?.navigationBar.tintColor = .white
//                    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//                    navigationController?.navigationBar.shadowImage = UIImage()
        

        headerView = tableView.tableHeaderView as! ProfileHeader
//                    headerView.imageView = trackImage
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
    
   override func viewWillAppear(_ animated: Bool) {
       getFirebaseData()
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
    func fetchCurrentUserData() {
         guard let currentUid = Auth.auth().currentUser?.uid else { return }
         
         Database.database().reference().child("users/profile").child(currentUid).observe(.value) { (snapshot) in
             print(snapshot)
             
             guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
             
             let uid = snapshot.key
             
             let user = User(uid: uid, dictionary: dictionary)
            
            self.user = user


         }
        
    }
    
    @IBAction func selectedUISegementControl(_ sender: UISegmentedControl) {
        
    }
    
    func getFirebaseData(){

            guard let uid = Auth.auth().currentUser?.uid else { return }
            self.databaseRef.child("users/profile").child(uid).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
                let dict = snapshot.value as? [String:Any]
                self.fullNameLabel.text = dict!["username"] as? String
//                self.title = dict!["username"] as? String
                self.whatDoYouConsiderYourself.text = dict!["What do you consider yourself?"] as? String
             self.bio.text = dict!["bio"] as? String

                if(dict!["photoURL"] != nil) {

                let databaseProfilePic = dict!["photoURL"] as! String

                    self.profilePic.loadImage(with: databaseProfilePic)
                    self.profilePic.layer.cornerRadius = self.profilePic.bounds.height / 2
                    self.profilePic.layer.masksToBounds = true
                    
                }

                if(dict!["headerURL"] != nil) {

                    let databaseHeaderPic = dict!["headerURL"] as! String

                    self.headerPic.loadImage(with: databaseHeaderPic)
                    self.headerPic.layer.masksToBounds = true
                }
            }

        }    
}

extension RandomTableViewController {
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .white
        segmentedControl = UISegmentedControl(frame: CGRect(x: 0, y:-15, width: tableView.frame.width, height: 30))
        segmentedControl.insertSegment(withTitle: "One", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Two", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Three", at: 2, animated: false)
        segmentedControl.tintColor = .white
        v.addSubview(segmentedControl)
                    tableView.estimatedSectionHeaderHeight = 40.0

        return v
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        return cell
    }
    
}


extension RandomTableViewController {
   
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
//
//
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
//
        }

    }

}
