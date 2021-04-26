//
//  SomthingElseCollectionViewTableViewCell.swift
//  audioPlayerApp
//
//  Created by William Hinson on 2/15/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class SomthingElseCollectionViewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var seCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //seCollectionView.register(UINib(nibName: "NewReleasesCollectionViewTableViewCell", bundle: nil), forCellWithReuseIdentifier: "NewReleasesCollectionViewTableViewCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension SomthingElseCollectionViewTableViewCell {
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDelegate & UICollectionViewDataSource>
        (_ dataSourceDelegate: D, forRow row:Int)
    {
        seCollectionView.delegate = dataSourceDelegate
        seCollectionView.dataSource = dataSourceDelegate
        
        seCollectionView.reloadData()
    }
}
