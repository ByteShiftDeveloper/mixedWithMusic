//
//  AddAudioTableViewCell.swift
//  audioPlayerApp
//
//  Created by William Hinson on 2/12/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class AddAudioTableViewCell: UITableViewCell {

    @IBOutlet weak var addAudioLabel: UILabel!
    @IBOutlet weak var addAudioDescription: UILabel!
    @IBOutlet weak var addAudioButton: UIButton!
    
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        self.addGesture()
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UploadTrackTableViewController.showActionSheet))
        addAudioButton.addGestureRecognizer(tap)
    }

}
