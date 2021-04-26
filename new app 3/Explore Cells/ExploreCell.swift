//
//  ExploreCell.swift
//  new app 3
//
//  Created by William Hinson on 6/28/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase


class ExploreCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var del : ExploreController?

    var songs = [SongPost]()
    let cellId : String = "SubCustomCell"
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "New Singles"
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
        grabAudioUpload()
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor,constant: 16 ).isActive = true
        
        setupSubCells()
        
        collectionView.register(SubCustomCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -API Calls
      
    func grabAudioUpload() {

      let ref = Database.database().reference().child("singles")
      ref.observe(.value) { (snapshot) in
          for child in snapshot.children {
              if let childSnapshot = child as? DataSnapshot,
                  let dict = childSnapshot.value as? [String:Any],
    //            let author = dict["uploadBy"] as? [String:Any],
                  let uid = dict["uid"] as? String,
                  let fullname = dict["username"] as? String,
                  let photoURL = dict["photoURL"] as? String,
                  let trackTitle = dict["trackTitle"] as? String,
                  let url = URL (string:photoURL),
    //            let likes = dictionary["likes"] as? Int,
                  let coverImageURL = dict["coverImage"] as? String,
                  let imageURL = URL (string:coverImageURL),
                  let audios = dict["AudioUrl"] as? [[String:Any]],
    //            let streams = dictionary["streams"] as? Int,
                  let timestamp = dict["timestampt"] as? Double {
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
        
                    let song = SongPost(id: childSnapshot.key, author: user, title: trackTitle, coverImage: imageURL, audioUrl: audioUrls , audioName: audioNames , likes: 0 , timestamp: timestamp, streams: 0)
                    self.songs.removeAll(where: {$0.id == childSnapshot.key})
                    self.songs.append(song)
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
            self.collectionView.setEmptyMessage("Be the first to upload a Single!")
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

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = 175
        let height = 175
        
        return CGSize(width: width, height: height)
        
    }

}
