//
//  FilterView.swift
//  new app 3
//
//  Created by William Hinson on 5/6/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FilterCell"

protocol ProfileFilterViewDelegate: class {
    func filterView(_ view:ProfileFilterView, didSelect index: Int)
}

class ProfileFilterView: UIView {
    
    weak var delegate: ProfileFilterViewDelegate?
    
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
        
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
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


extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileFilterCell
        
        let option = ProfileFilterOptions(rawValue: indexPath.row)
        cell.option = option
        
        return cell
        
    }
}

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let count = CGFloat(ProfileFilterOptions.allCases.count)
        return CGSize(width: frame.width / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ProfileFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let cell = collectionView.cellForItem(at: indexPath)
        
        let xPosition = cell?.frame.origin.x ?? 0
        
        UIView.animate(withDuration: 0.3) {
            self.underLineView.frame.origin.x = xPosition
        }
        delegate?.filterView(self, didSelect: indexPath.row)
    }
}
