//
//  SearchFilterUserCVC.swift
//  new app 3
//
//  Created by William Hinson on 10/29/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase


class SearchFilterUserCVC: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var del : SearchFilterCollectionViewController?

    var abdmp = ["Artist", "Band", "DJ", "Musician", "Producer"]
    let cellId : String = "SubFilterUserCVC"
    var selectedabdmp : [String] = []
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "User Filter"
        label.font = UIFont.boldSystemFont(ofSize: 24)
//        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        //        cv.alwaysBounceHorizontal = true
        return cv
    }()
    
    fileprivate func setupSubCells() {
        addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        collectionView.isScrollEnabled = true
        collectionView.isUserInteractionEnabled = true
        collectionView.showsHorizontalScrollIndicator = false

    }
    
    @objc func handleCancle() {
        del?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
       print("Successfully clicked donne")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor,constant: 8 ).isActive = true
        
        setupSubCells()
        
        collectionView.register(SubFilterUserCVC.self, forCellWithReuseIdentifier: cellId)
        
//        let underlineView = UIView()
//        underlineView.backgroundColor = .systemGroupedBackground
//        self.contentView.addSubview(underlineView)
//        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor,
//                             right: rightAnchor, height: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnClicked(_ sender : UIButton){
        print("Selecting this button \(sender.tag)")

    }
    
    //MARK: -API Calls
      
    
    //MARK: -CollectionViewFuncs
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return abdmp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SubFilterUserCVC
        cell.genre = abdmp[indexPath.row]
//        cell.filterUserButton.addTarget(del, action: #selector(btnClicked), for: .touchUpInside)
//        cell.filterUserButton.tag = indexPath.row
        
        if selectedabdmp.contains(abdmp[indexPath.row]){
            cell.filterUserButton.backgroundColor = .black
            cell.filterUserButton.setTitleColor(.white, for: .normal)
        }else{
            cell.filterUserButton.backgroundColor = .clear
            cell.filterUserButton.setTitleColor(.black, for: .normal)
        }
        cell.delegate = self
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selecting this button \(123)")

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 180
        let height = 50
        
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

}

extension SearchFilterUserCVC: UserFilterDelegate {
    func handleSelect(_ cell: SubFilterUserCVC) {
        print("Selecting this button \(cell.genre)")
        if selectedabdmp.contains(cell.genre){
            selectedabdmp.removeAll(where: {$0 == cell.genre})
            cell.filterUserButton.backgroundColor = .clear
            cell.filterUserButton.setTitleColor(.black, for: .normal)
        }else{
            selectedabdmp.append(cell.genre)
            cell.filterUserButton.backgroundColor = .black
            cell.filterUserButton.setTitleColor(.white, for: .normal)
        }
        
    }
}
