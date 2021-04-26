//
//  GenreCollectionView.swift
//  new app 3
//
//  Created by William Hinson on 8/27/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

private let headerIdentifier = "GenreCollectionViewHeader"
private let cellId = "GenreUploadCollectionView"

class GenreCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var genre = String() {
        didSet {
//            genreView.backgroundColor = genre
//            self.backgroundColor = genre
//                titleLabel.text = genre
        }
    }
    
    var color = UIColor() {
        didSet {
//                backgroundColor = color
        }
    }
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    let keyWindow = UIApplication.shared.connectedScenes
               .map({$0 as? UIWindowScene})
               .compactMap({$0})
               .first?.windows.first
    
    var statusBarUIView: UIView? {

      if #available(iOS 13.0, *) {
          let tag = 3848245

          let keyWindow = UIApplication.shared.connectedScenes
              .map({$0 as? UIWindowScene})
              .compactMap({$0})
              .first?.windows.first

          if let statusBar = keyWindow?.viewWithTag(tag) {
              return statusBar
          } else {
              let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
              let statusBarView = UIView(frame: height)
              statusBarView.tag = tag
              statusBarView.layer.zPosition = 999999

              keyWindow?.addSubview(statusBarView)
              return statusBarView
          }

      } else {

          if responds(to: Selector(("statusBar"))) {
              return value(forKey: "statusBar") as? UIView
          }
      }
      return nil
    }
    
    var songs = [SongPost]()

    var previousOffsetState: CGFloat = 0
    var navigationHeight : CGFloat = 50
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        collectionView.register(GenreCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        collectionView.register(GenreUploadCollectionView.self, forCellWithReuseIdentifier: cellId)

        
        setupCollectionView()
        genreFetch()
        
    }
    
    func genreFetch() {
        var songs = [SongPost]()
                  
        Database.database().reference().child("audio-by-genres").child(genre).observe(.childAdded) { snapshot in
            let uploadID = snapshot.key
            print("Genre fetch is \(uploadID)")
            
                      
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
    
        fileprivate func setupCollectionView() {
            collectionView.backgroundColor = UIColor(named: "DefaultBackgroundColor")
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.alwaysBounceVertical = true
             if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
                 let padding: CGFloat = 0
                 layout.sectionInset = .init(top: padding, left: 0, bottom: padding, right: 0)
             }
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
            self.navigationItem.title = genre
             
    //         collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
//            collectionView.register(SongCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
//             collectionView.register(SongHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
         }
        
//            override func viewWillAppear(_ animated: Bool) {
//                super.viewWillAppear(animated)
//                guard let tabBar = self.tabBarController?.tabBar else { return }
//                tabBar.tintColor = UIColor.white
//                tabBar.barTintColor = Colors.darkGray
//                tabBar.isTranslucent = false
//        //      navigationController?.navigationBar.backgroundColor = Colors.blackColor
//
//
//            }
            
               
//            override func viewWillDisappear(_ animated: Bool) {
//                guard let tabBar = self.tabBarController?.tabBar else { return }
//                tabBar.tintColor = UIColor.black
//                tabBar.barTintColor = UIColor.white
//                tabBar.isTranslucent = false
//               }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GenreUploadCollectionView
        cell.song = songs[indexPath.row]
        return cell

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = SelectSongController(collectionViewLayout: StretchyHeaderLayout())
        controller.song = songs[indexPath.row]
        controller.user = songs[indexPath.row].author
        navigationController?.pushViewController(controller, animated: true)


    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! GenreCollectionViewHeader
        header.genre = genre
        header.color = color
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
               return CGSize(width: view.frame.height, height: 200)
       }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y / 82
        if offset > 1 {
            offset = 1
            let color1  = UIColor(hue: 0, saturation: offset, brightness: 0, alpha: 1)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.backgroundColor = color.withAlphaComponent(offset)
            statusBarUIView?.backgroundColor = color.withAlphaComponent(offset)

        } else {
//            let color  = UIColor(hue: 0, saturation: offset, brightness: 0, alpha: 1)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
            self.navigationController?.navigationBar.backgroundColor = color.withAlphaComponent(offset)
            statusBarUIView?.backgroundColor = color.withAlphaComponent(offset)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           let width = 190
           let height = 210
           
           return CGSize(width: width, height: height)
           
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

}

