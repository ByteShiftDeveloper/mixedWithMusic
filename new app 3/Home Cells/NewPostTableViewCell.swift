//
//  NewPostTableViewCell.swift
//  new app 3
//
//  Created by William Hinson on 1/9/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class NewPostTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(post:Post) {
        usernameLabel.text = post.author.fullname
        postLabel.text = post.text
    }

}
