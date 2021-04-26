//
//  SelectAudioFileTableViewCell.swift
//  audioPlayerApp
//
//  Created by William Hinson on 2/5/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol AlertShower {
    func showAlert(_: SelectAudioFileTableViewCell)
}

class SelectAudioFileTableViewCell: UITableViewCell {

 @IBOutlet weak var selectAudioLabel: UILabel!
 @IBOutlet weak var decriptionAudioLabel: UILabel!
    @IBOutlet weak var addAudioButton: UIButton!
    
}
