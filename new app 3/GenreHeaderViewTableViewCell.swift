//
//  GenreHeaderViewTableViewCell.swift
//  new app 3
//
//  Created by William Hinson on 3/24/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class GenreHeaderViewTableViewCell: UITableViewCell {

    @IBOutlet weak var ghcollectionview: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension GenreHeaderViewTableViewCell {
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDelegate & UICollectionViewDataSource>
        (_ dataSourceDelegate: D, forRow row:Int)
    {
        ghcollectionview.delegate = dataSourceDelegate
        ghcollectionview.dataSource = dataSourceDelegate
        
        ghcollectionview.reloadData()
    }
}
