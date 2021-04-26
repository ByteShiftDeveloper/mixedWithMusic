//
//  NewReleasesInsideTableViewCellCollectionViewCell.swift
//  audioPlayerApp
//
//  Created by William Hinson on 2/15/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class NewReleasesInsideTableViewCellCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    
     weak var song:SongPost?
        
        func set(song:SongPost) {
            self.song = song
            
            ImageService.getImage(withURL: song.coverImage) { image in
             self.coverImage.image = image
            }
        
            
            trackTitle.text = self.song?.title
        
        }
}
