//
//  NewMessageTableViewCell.swift
//  new app 3
//
//  Created by William Hinson on 4/20/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class NewMessageTableViewCell: UITableViewCell {
    
    var user: User? {
        
        didSet{

            guard let username = user?.username else { return }
            userName?.text = username
            guard let profilePicURL = user?.profileImageURL else { return }
            profilePic.loadImage(with: profilePicURL)
            profilePic.layer.cornerRadius = profilePic.bounds.height / 2
            profilePic.clipsToBounds = true
            
        }
        
    }

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
