//
//  FeaturedArtistsInsideTableViewCellCollectionViewCell.swift
//  audioPlayerApp
//
//  Created by William Hinson on 2/15/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class FeaturedArtistsInsideTableViewCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    
    var user: User? {
          
          didSet {
          
          guard let profileImageURL = user?.profileImageURL else { return }
            guard let username = user?.fullname else { return }
          guard let artistsBand = user?.artistBand else { return }
              
              
              userPic.loadImage(with: profileImageURL)
              
              self.username?.text = username
          }
      }
    
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
           
           userPic.layer.cornerRadius = userPic.bounds.height / 2
           userPic.clipsToBounds = true
       }

}
