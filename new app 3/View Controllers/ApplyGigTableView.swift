//
//  ApplyGigTableView.swift
//  new app 3
//
//  Created by William Hinson on 3/4/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip
import Firebase

private let reuseIdent = "DescriptionTVC"
private let reuseIdent2 = "GigTimeCVC"
private let reuseIdent3 = "PrefferedGenreCVC"
private let headerIdentifier = "HeaderView3"
private let footerIdent = "GigApplyFooter"

class ApplyGigTableView: UICollectionViewController {
    
    var gigs: Gigs?
    
    var pageIndex: Int = 0
    var pageTitle: String?
    
    var selectedFilter: GigFilterOptions = .gigs {
        didSet {
            collectionView.reloadData() }
    }
    
    init(gigs: Gigs) {
           self.gigs = gigs
           super.init(collectionViewLayout: UICollectionViewFlowLayout())
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    var count = 0
    
    var footerCell : GigApplyFooterButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        checkifUserApplied()
        collectionView.backgroundColor = UIColor(named: "DefaultBackgroundColor")
        collectionView.register(DescriptionCVC.self, forCellWithReuseIdentifier: reuseIdent)
        collectionView.register(GigTimeCVC.self, forCellWithReuseIdentifier: reuseIdent2)
        collectionView.register(PreferredGenreCVC.self, forCellWithReuseIdentifier: reuseIdent3)
        collectionView.register(GigApplyFooterButton.self, forCellWithReuseIdentifier: footerIdent)
        
    }
    
    func checkifUserApplied() {
        guard let gig = gigs else { return }
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        Service.shared.checkIfUserAppled(gig) { didApply in
            if gig.didApply == true {
                self.footerCell?.uploadButton.setTitle("Applied", for: .normal)
            } else if gig.didApply == false {
                self.footerCell?.uploadButton.setTitle("Apply", for: .normal)
            }
        }
    }
    
    
    func uploadEPKURL() {
        print("Attemtping to present upload")
        let alertController = UIAlertController(title: "You must upload an EPK before applying to this gig!", message: "", preferredStyle: .alert)
        

        // Add a textField to your controller, with a placeholder value & secure entry enabled
 
        // A cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Canelled")
        }

        // This action handles your confirmation action
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let controller = EditProfileTableViewController(user: user)
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true) {
                    controller.handleEPK()
                }
                
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ApplyGigTableView {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdent2, for: indexPath) as! GigTimeCVC
            cell.gigs = gigs
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdent3, for: indexPath) as! PreferredGenreCVC
            cell.gigs = gigs
            return cell
        } else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: footerIdent, for: indexPath) as! GigApplyFooterButton
            cell.gigs = gigs
            cell.delegate = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdent, for: indexPath) as! DescriptionCVC
        cell.gigs = gigs
        return cell
    }
    
}

extension ApplyGigTableView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 50
        if indexPath.section == 1 {
            
            height += textHeight(text: gigs!.text) - 30
            
        } else if indexPath.section == 3 {
            height += 10
        }
        return CGSize(width: view.frame.width, height: height)
    }

}

extension ApplyGigTableView: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab \(pageIndex)")
    }
}

extension ApplyGigTableView {
    func textHeight(text : String) -> CGFloat{
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: CGFloat.greatestFiniteMagnitude))
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        return label.frame.height
    }
}

extension ApplyGigTableView: GigApplyDelegate {
    func handleTap(_ cell: GigApplyFooterButton) {
        guard let gigs = cell.gigs else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        UserService.shared.fetchUser(uid: uid) { user in
            if user.epkPDF == "" || user.epkURL == "" {
                self.uploadEPKURL()
            } else if user.epkPDF != "" || user.epkURL != "" {
                
                Service.shared.applyToGig(gig: gigs) { (err, ref) in
                    let applications = gigs.didApply ? gigs.applications + 0 : gigs.applications + 1
                    cell.gigs?.didApply.toggle()
                    cell.gigs?.applications = applications
                    print("Successfully applied to gig!")
                    self.checkifUserApplied()
                    NotificationService.shared.uploadNotification(type: .gigApplication, gig: self.gigs)
                    cell.uploadButton.setTitle("Applied!", for: .normal)
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

