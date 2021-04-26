//
//  TrackTableViewCell.swift
//  audioPlayerApp
//
//  Created by William Hinson on 1/28/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var trackNumber: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var addInfo: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
