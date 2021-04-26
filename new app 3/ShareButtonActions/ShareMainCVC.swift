//
//  ShareMainCVC.swift
//  new app 3
//
//  Created by William Hinson on 10/22/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

class ShareMainCVC: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
//    var del : ExploreController?
    
    let cellId3 : String = "ShareCVC"
    var users = [User]()
    var del : ShareSheetLaunch?

    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Featured Users"
        label.font = UIFont.boldSystemFont(ofSize: 24)
//        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
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
        fetchUser()
        
        setupSubCells()
        
        collectionView.register(ShareCVC.self, forCellWithReuseIdentifier: cellId3)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor,
                             right: rightAnchor, height: 1)
        
//        view.addSubview(blurEffectView)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId3, for: indexPath) as! ShareCVC
//        cell.backgroundColor = .yellow
        cell.user = users[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = users[indexPath.row] as? User else { return }
//        let controller = ProfileCollectionViewController(user: user)
//        let controller = NewProfileVC()
//        controller.user = user
//        del?.showChatController(forUser: user)
   
        

        del?.sendButton.isEnabled = true
        del?.user = user
//        del?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 70
        let height = 100
        
        return CGSize(width: width, height: height)
        
    }
    
}

//extension ShareMainCVC: ShareCVCDelegate {
//    func handleSelect(_ cell: ShareCVC) {
//        print("SUCCESSFULLY SELECTED USER")
//    }
//}
