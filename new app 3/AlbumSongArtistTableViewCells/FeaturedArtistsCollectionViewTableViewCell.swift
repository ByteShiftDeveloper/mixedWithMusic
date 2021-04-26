//
//  FeaturedArtistsCollectionViewTableViewCell.swift
//  audioPlayerApp
//
//  Created by William Hinson on 2/15/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class FeaturedArtistsCollectionViewTableViewCell: UITableViewCell {

    @IBOutlet weak var faCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //faCollectionView.register(UINib(nibName: "FeaturedArtistsInsideTableViewCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeaturedArtistsInsideTableViewCellCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FeaturedArtistsCollectionViewTableViewCell {
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDelegate & UICollectionViewDataSource>
        (_ dataSourceDelegate: D, forRow row:Int)
    {
        faCollectionView.delegate = dataSourceDelegate
        faCollectionView.dataSource = dataSourceDelegate
        
        faCollectionView.reloadData()
    }
}

