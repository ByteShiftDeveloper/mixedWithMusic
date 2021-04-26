//
//  SFilterView.swift
//  new app 3
//
//  Created by William Hinson on 10/29/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Foundation

private let reuseIdentifier = "FilterCell"

protocol SearchFilterViewDelegate: class {
    func filterView(_ view:SFilterView, didSelect index: Int)
}

class SFilterView: UIView {
    
    weak var delegate: SearchFilterViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let underLineView: UIView = {
        let view = UIView()
         view.backgroundColor = .black
         return view
     }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(SearchFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubview(underLineView)
              underLineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 2)
    }
}


extension SFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SearchFilterOptions.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchFilterCell
        
        let option = SearchFilterOptions(rawValue: indexPath.row)
        cell.option = option
        
        return cell
        
    }
}

extension SFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let count = CGFloat(SearchFilterOptions.allCases.count)
        return CGSize(width: frame.width / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension SFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let cell = collectionView.cellForItem(at: indexPath)
        
        let xPosition = cell?.frame.origin.x ?? 0
        
        UIView.animate(withDuration: 0.3) {
            self.underLineView.frame.origin.x = xPosition
        }
        delegate?.filterView(self, didSelect: indexPath.row)
    }
}
