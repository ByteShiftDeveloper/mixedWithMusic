//
//  ShowLikeTableViewCell.swift
//  new app 3
//
//  Created by William Hinson on 5/4/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class ShowLikeTableViewCell: UITableViewCell {

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
}
