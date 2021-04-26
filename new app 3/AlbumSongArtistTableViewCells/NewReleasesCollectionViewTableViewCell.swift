//
//  NewReleasesCollectionViewTableViewCell.swift
//  audioPlayerApp
//
//  Created by William Hinson on 2/15/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class NewReleasesCollectionViewTableViewCell: UITableViewCell {

    @IBOutlet weak var nrCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //nrCollectionView.register(UINib(nibName: "NewReleasesCollectionViewTableViewCell", bundle: nil), forCellWithReuseIdentifier: "NewReleasesCollectionViewTableViewCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NewReleasesCollectionViewTableViewCell {
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDelegate & UICollectionViewDataSource>
        (_ dataSourceDelegate: D, forRow row:Int)
    {
        nrCollectionView.delegate = dataSourceDelegate
        nrCollectionView.dataSource = dataSourceDelegate
        
        nrCollectionView.reloadData()
    }
}

