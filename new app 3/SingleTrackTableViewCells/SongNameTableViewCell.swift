//
//  SongNameTableViewCell.swift
//  audioPlayerApp
//
//  Created by William Hinson on 2/4/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class SongNameTableViewCell: UITableViewCell {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songNumberLabel: UILabel!
    
    weak var song:SongPost?
    
    func set(song:SongPost) {
               self.song = song
               
//               ImageService.getImage(withURL: song.coverImage) { image in
//                self.coverImage.image = image
//               }
           
        self.songName.text = self.song?.title
        
           }

}
