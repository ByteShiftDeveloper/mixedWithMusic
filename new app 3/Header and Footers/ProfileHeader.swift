//
//  ProfileHeader.swift
//  new app 3
//
//  Created by William Hinson on 4/13/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

class ProfileHeader: UIView {
    
    private let filterbar = ProfileFilterView()
    
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        
        didSet{
            
            configureFollowButton()
            
            fullNameLabel.text = user?.username
            bio.text = user?.bio
            whatDoYouConsiderYourself.text = user?.artistBand
            guard let profileImageURL = user?.profileImageURL else { return }
            
            if profilePic == nil {
                profilePic.backgroundColor = .lightGray

            }  else {
                profilePic.loadImage(with: profileImageURL)

            }
            
            profilePic.layer.cornerRadius = profilePic.bounds.height / 2
            profilePic.clipsToBounds = true
                        
            guard let headerImageURL = user?.headerImageURL else { return }
           
            if headerPic == nil {
        
                headerPic.backgroundColor = .lightGray
            }  else {
                headerPic.loadImage(with: headerImageURL)
            }
            
        }
    }

    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var headerPic: UIImageView!
    @IBOutlet weak var whatDoYouConsiderYourself: UILabel!
    @IBOutlet weak var followUnfollowButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
    
    
    
    
    
    func configureFollowButton() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else { return }
        
        followUnfollowButton.setTitle("Follow", for: .normal)
        followUnfollowButton.setTitleColor(.black, for: .normal)
        followUnfollowButton.layer.borderWidth = 2.0
        followUnfollowButton.layer.borderColor = Colors.blackColor.cgColor
    }
    
    
    @objc func handleFollow() {
        delegate?.handleEditFollowTapped(for: self)
    }
    
}
