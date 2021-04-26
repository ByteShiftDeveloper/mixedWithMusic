//
//  ExploreCell3.swift
//  new app 3
//
//  Created by William Hinson on 7/1/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

protocol ExploreCell3Delegate: class {
    func buttonTapped(_ cell: ExploreCell3)
}


class ExploreCell3: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var del : ExploreController?
    
    let cellId3 : String = "SubCustomCell3"
    var users = [User]()
    
    var delegate: ExploreCell3Delegate?
    
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Featured Users"
        label.font = UIFont.boldSystemFont(ofSize: 24)
//        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "BlackColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.alwaysBounceHorizontal = true
        return cv
    }()
    
    fileprivate func setupSubCells() {
        addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .clear
        
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        collectionView.showsHorizontalScrollIndicator = false


    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        fetchUser()
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: -6).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor,constant: 16 ).isActive = true
        
        setupSubCells()
        
        collectionView.register(SubCustomCell3.self, forCellWithReuseIdentifier: cellId3)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -API Calls
    func fetchUser(){
      
          Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
              print(snapshot)
              
              guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
              
              let uid = snapshot.key
              
              let user = User(uid: uid, dictionary: dictionary)
              
              self.users.append(user)
            
              self.collectionView.reloadData()
              
          }
      
      }
    
    //MARK: -CollectionViewFuncs
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId3, for: indexPath) as! SubCustomCell3
//        cell.backgroundColor = .yellow
        cell.user = users[indexPath.row]
        return cell
    }
    
    @objc func ButtonTap() {
        delegate?.buttonTapped(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = users[indexPath.row] as? User else { return }
//        let controller = ProfileCollectionViewController(user: user)
        let controller = NewProfileVC()
        controller.user = user
        del?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 200
        let height = 240
        
        return CGSize(width: width, height: height)
        
    }

}
