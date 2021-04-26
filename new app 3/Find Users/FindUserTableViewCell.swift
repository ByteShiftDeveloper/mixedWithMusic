//
//  FindUserTableViewCell.swift
//  new app 3
//
//  Created by William Hinson on 12/30/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

class FindUserTableViewCell: UITableViewCell {
    
    
    var user: User? {
        
        didSet {
//        
//        guard let profileImageURL = user?.profileImageURL else { return }
//        guard let fullname = user?.fullname else { return }
//        
//        profilePic.loadImage(with: profileImageURL)
//        self.usernameLabel?.text = fullname
        }
    }
    

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var artistDJLabel: UILabel!
    @IBOutlet weak var followButton: FollowButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profilePic.layer.cornerRadius = profilePic.bounds.height / 2
        profilePic.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
//    weak var user:Users?
//    func set(users:Users) {
//    self.user = users
//
//    ImageService.getImage(withURL: users.author.photoURL) { image in
//
//
//
//        self.profilePic.image = image
//        }
//
//        self.usernameLabel.text = users.author.fullname
//        self.artistDJLabel.text = users.artistDJBand
//
//    }
}
