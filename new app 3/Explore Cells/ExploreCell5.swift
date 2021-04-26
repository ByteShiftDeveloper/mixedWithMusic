//
//  ExploreCell5.swift
//  new app 3
//
//  Created by William Hinson on 10/27/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

protocol LikesDelegate: class {
    func handleSeeAll(_ cell: ExploreCell5)
}


class ExploreCell5: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var del : ExploreController?

    var songs = [SongPost]()
    
    var delegate: LikesDelegate?
    
    let cellId : String = "SubCustomCell"
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Liked Songs"
        label.font = UIFont.boldSystemFont(ofSize: 24)
//        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "BlackColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let seeMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("See all", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleSeeAll), for: .touchUpInside)
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
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
//        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
//        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8)
        
        collectionView.showsHorizontalScrollIndicator = false

    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fetchSingle()
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor,constant: 16 ).isActive = true
//        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
//        titleLabel.leftAnchor.constraint(equalTo: leftAnchor,constant: 8 ).isActive = true
        
        addSubview(seeMoreButton)
        seeMoreButton.anchor(bottom: titleLabel.bottomAnchor, right: rightAnchor, paddingBottom: -4, paddingRight: 8)
        seeMoreButton.addTarget(self, action: #selector(handleSeeAll), for: .touchUpInside)
//        seeMoreButton.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
//        seeMoreButton.rightAnchor.constraint(equalTo: rightAnchor, constant: 8).isActive = true
        
        setupSubCells()
        
        collectionView.register(SubCustomCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    @objc func handleSeeAll() {
        delegate?.handleSeeAll(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -API Calls
      
    func fetchSingle() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        USER_SONG_LIKES.child(uid).observe(.childAdded) { snapshot in
                     let uploadID = snapshot.key
              
              print("upload id id \(uploadID)")
              
              UPLOADS_REF.child(uploadID).observeSingleEvent(of: .value) { snapshot in
                  print("audio is \(snapshot)")

                      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                                        
              
                                  //                      let author = dict["uploadBy"] as? [String:Any],
                                          guard let uid = dictionary["uid"] as? String else { return }
                                          guard let fullname = dictionary["username"] as? String else { return }
                                          guard let photoURL = dictionary["photoURL"] as? String else { return }
                                          guard let trackTitle = dictionary["trackTitle"] as? String else { return }
                                          guard let url = URL (string:photoURL) else { return }
                                          guard let coverImageURL = dictionary["coverImage"] as? String else { return }
                                          guard let imageURL = URL (string:coverImageURL) else { return }
                                          guard let audios = dictionary["AudioUrl"] as? [[String:Any]] else { return }
                                            guard let likes = dictionary["likes"] as? Int else { return }
                                            guard let streams = dictionary["streams"] as? Int else { return }

                                                            //let songURL = URL (string:audioURL),
                                        
                                          guard let  timestamp = dictionary["timestampt"] as? Double else { return }; do {
                                        
                                          var audioNames  = [String]()
                                          var audioUrls  = [URL]()
                                          for audio in audios{
                                          let audioName = audio.first?.key
                                          let audioUrl = audio.first?.value as? String
                                          let songURL = URL (string:audioUrl!)
                                        
                                          audioNames.append(audioName!)
                                          audioUrls.append(songURL!)
                                  }
                                        
                                  UserService.shared.fetchUser(uid: uid) { user in
                                  
                                    let song = SongPost(id: snapshot.key, author: user, title: trackTitle, coverImage: imageURL, audioUrl: audioUrls , audioName: audioNames, likes: likes , timestamp: timestamp, streams: streams)
                                                      
                                    self.songs.append(song)
                                                                              //
                                    self.songs = self.songs.sorted(by: { $0.createdAt > $1.createdAt})

                                                          
                                    self.collectionView.reloadData()

                      }
                  }
              }
          }
      }

    
    //MARK: -CollectionViewFuncs
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.songs.count == 0) {
            self.collectionView.setEmptyMessage("The songs you like will appear here, get started by liking your favorite songs!")
        } else {
            self.collectionView.restore()
        }
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SubCustomCell
        cell.backgroundColor = .clear
        cell.song = songs[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = SelectSongController(collectionViewLayout: StretchyHeaderLayout())
        controller.song = songs[indexPath.row]
        controller.user = songs[indexPath.row].author
        del?.navigationController?.pushViewController(controller, animated: true)
        del?.handleRefresh()

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 150
        let height = 150
        
        return CGSize(width: width, height: height)
        
    }

}
