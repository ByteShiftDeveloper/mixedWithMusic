//
//  ExploreCell2.swift
//  new app 3
//
//  Created by William Hinson on 7/1/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit


class ExploreCell2: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var del : ExploreController?

    let cellId2 : String = "SubCustomCell2"
    
    var genre = [Colors.genre1, Colors.genre2, Colors.genre3, Colors.genre4, Colors.genre5, Colors.genre6, Colors.genre7, Colors.genre8, Colors.genre9, Colors.genre10, Colors.genre11, Colors.genre12, Colors.genre13, Colors.genre14, Colors.genre15, Colors.genre16, Colors.genre17, Colors.genre18, Colors.genre19, Colors.genre20, Colors.genre21, Colors.genre22, Colors.genre23, Colors.genre24, Colors.genre25, Colors.genre26, Colors.genre27, Colors.genre28, Colors.genre29, Colors.genre30, Colors.genre31, Colors.genre32]
    
    var genresArray = [ "Alternative","Blues","Children's Music","Christian & Gospel", "Classical","Comedy","Country","Dance","EDM","Electronic","French Pop","German Folk","Hip-Hop/Rap","Holiday","Indie Pop","Industrial","Instrumental","J-Pop","Jazz","K-Pop","Latin","New Age","Opera","Pop","R&B/Soul","Reggae","Rock","Songwriter","Soundtrack","Tex-Mex/Tejano","Vocal","World"]

    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Genres"
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

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

        
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        collectionView.showsHorizontalScrollIndicator = false

    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor,constant: 16 ).isActive = true
        
        setupSubCells()
        
        collectionView.register(SubCustomCell2.self, forCellWithReuseIdentifier: cellId2)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -API Calls
    
    //MARK: -CollectionViewFuncs
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genresArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! SubCustomCell2
//        cell.backgroundColor = .yellow
        cell.genre = genresArray[indexPath.row]
        cell.color = genre[indexPath.row]
//        cell.genre
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let controller = GenreCollectionView(collectionViewLayout: StretchyHeaderLayout())
         controller.genre = genresArray[indexPath.row]
         controller.color = genre[indexPath.row]
         del?.navigationController?.pushViewController(controller, animated: true)

     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 190
        let height = 100
        
        return CGSize(width: width, height: height)
        
    }

}
