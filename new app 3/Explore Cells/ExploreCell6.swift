//
//  ExploreCell6.swift
//  new app 3
//
//  Created by William Hinson on 2/26/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase



protocol ExploreCell6Delegate: class {
    func buttonTapped(_ cell: ExploreCell6)
    func seeMoreButtonTapped(_ cell: ExploreCell6)
}


class ExploreCell6: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var del : ExploreController?
    
    let cellId6 : String = "SubCustomCell6"
    var users = [User]()
    var gigs = [Gigs]()
    
    weak var delegate: ExploreCell6Delegate?
    
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Gigs"
        label.font = UIFont.boldSystemFont(ofSize: 24)
//        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "BlackColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    let seeMoreButton: UILabel = {
//        let label = UILabel()
//        label.text = "See all"
//        label.textColor = .lightGray
//        label.font = UIFont.systemFont(ofSize: 16)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(ButtonTap))
//        label.addGestureRecognizer(tap)
//        label.isUserInteractionEnabled = true
//        return label
//    }()
    
    let seeMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("See all", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
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
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: -8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor,constant: 16 ).isActive = true
        
        contentView.addSubview(seeMoreButton)
        seeMoreButton.anchor(bottom: titleLabel.bottomAnchor, right: rightAnchor, paddingBottom: -4, paddingRight: 16)
        seeMoreButton.isUserInteractionEnabled = true
        seeMoreButton.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(ButtonTap))
//        seeMoreButton.addGestureRecognizer(tap)
//        seeMoreButton.isUserInteractionEnabled = true
        fetchGigs()
        setupSubCells()
        
        collectionView.register(SubCustomCell6.self, forCellWithReuseIdentifier: cellId6)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -API Calls
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
      
          Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
              print(snapshot)
              
              guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
              let uid = snapshot.key
              let user = User(uid: uid, dictionary: dictionary)
              completion(user)

          }
      
      }
    
    func fetchGigs() {
        Database.database().reference().child("gigs").observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
            let uid = dictionary["uid"] as? String ?? ""
            let gigId = snapshot.key
            
            print("DEBUG: Snapshot is \(snapshot)")
            
            UserService.shared.fetchUser(uid: uid) { user in
                let gig = Gigs(GigId: gigId, user: user, dictionary: dictionary)
                self.gigs.append(gig)
                self.gigs = self.gigs.sorted(by: { $0.createdAt > $1.createdAt})
                self.collectionView.reloadData()
            }
            
        }
    }
    
    //MARK: -CollectionViewFuncs
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gigs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId6, for: indexPath) as! SubCustomCell6
//        cell.backgroundColor = .yellow
        cell.gig = gigs[indexPath.row]
        return cell
    }
    
    @objc func ButtonTap() {
        delegate?.buttonTapped(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let gig = gigs[indexPath.row] as? Gigs else { return }
        let user = gigs[indexPath.row].user
//        let controller = ProfileCollectionViewController(user: user)
        let controller = ApplyToGigController()
        controller.gigs = gig
        controller.user = user
        del?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 200
        let height = 240
        
        return CGSize(width: width, height: height)
        
    }
    
    @objc func handleButtonTap() {
        delegate?.seeMoreButtonTapped(self)
    }
}
