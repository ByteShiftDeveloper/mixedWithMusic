//
//  ShareTVC.swift
//  new app 3
//
//  Created by William Hinson on 10/22/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Foundation

private let cellReuseidentifier = "ShareCVC"

class ShareTVC : UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {


required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: cellReuseidentifier)
        setupViews()

}

override func layoutSubviews() {
    super.layoutSubviews()
}


let imagesCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = UIColor.white
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
}()


func setupViews() {
    backgroundColor = UIColor.black
    addSubview(imagesCollectionView)
    imagesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseidentifier)
    imagesCollectionView.dataSource = self
    imagesCollectionView.delegate = self
    
}

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseidentifier, for: indexPath)
    cell.backgroundColor = .green
    return cell
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: frame.width, height: 30)
}
}
