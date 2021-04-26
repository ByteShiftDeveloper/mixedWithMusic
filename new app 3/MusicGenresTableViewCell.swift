//
//  MusicGenresTableViewCell.swift
//  new app 3
//
//  Created by William Hinson on 2/25/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class MusicGenresTableViewCell: UITableViewCell {
    
    @IBOutlet weak var genreLabel: UILabel?
    @IBOutlet weak var uncheckedButton: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func uncheckedButtonPressed(_ sender: Any) {
    }
    
}
