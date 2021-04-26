//
//  SelectSongController.swift
//  new app 3
//
//  Created by William Hinson on 7/3/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class SelectSongController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    
    var song: SongPost? {
        didSet {
            }
        }
    
    let keyWindow = UIApplication.shared.connectedScenes
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows.first
    
    var user: User?
    
    var songheader: SongHeader?
    
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
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()

    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.alwaysBounceVertical = true
         if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
             let padding: CGFloat = 0
             layout.sectionInset = .init(top: padding, left: 0, bottom: padding, right: 0)
         }
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        self.navigationItem.title = song?.title
         
//         collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(SongCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
         collectionView.register(SongHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
     }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationBar.prefersLargeTitles = false


        }
    
    let player: AVPlayer = {
       let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
        
           
        override func viewWillDisappear(_ animated: Bool) {
//            guard let tabBar = self.tabBarController?.tabBar else { return }
//            tabBar.tintColor = UIColor.black
//            tabBar.barTintColor = UIColor.white
//            tabBar.isTranslucent = false
            navigationController?.setNavigationBarHidden(true, animated: false)
           }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (song?.audioName.count)!
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SongCollectionViewCell
        cell.songTitle.text = song?.audioName[indexPath.row]
        cell.songNumber.text = String(indexPath.row + 1)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let song = song else { return }
        
      
        
//        TabBarController.playersDetailView.handleTapMaximize()
//        TabBarController.playersDetailView.song = song
//        TabBarController.playersDetailView.songs = [song]
        
        let y = self.view.frame.height  - 64
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.addPlayerView(song: song)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SongHeader
        header.song = self.song
        header.delegate = self
    
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 416)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
           var offset = scrollView.contentOffset.y / 296
           if offset > 1 {
               offset = 1
               let color  = UIColor(hue: 0, saturation: offset, brightness: 0, alpha: 1)
               self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
               self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
               statusBarUIView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: offset)

           } else {
//               let color  = UIColor(hue: 0, saturation: offset, brightness: 0, alpha: 1)
               self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
               self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
               statusBarUIView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
           }
       }
}

extension SelectSongController: SongHeaderDelegate {
    func handleNameTap(_ header: SongHeader) {
        guard let user = user else { return }
//        let controller = ProfileCollectionViewController(user: user)
        let controller = NewProfileVC()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
        print("This was tapped")
    }
    
    
    func handlePlayButtonTapped(_ header: SongHeader) {
        print("tapped header play button")
        
//        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
//
//
//
//        let playerView = PlayerDetailController.initFromNib()
//        window.addSubview(playerView)
//        playerView.song = song
//        playerView.miniPlayerView.isHidden = true
//
        let y = self.view.frame.height - (tabBarController?.tabBar.frame.height ?? 0 ) - 64
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.addPlayerView(song: song)
        
        
        

//        TabBarController.playersDetailView.handleTapMaximize()
//        TabBarController.playersDetailView.song = song
    }

    func handleProfileImageTapped(_ header: SongHeader) {
        print("image tapped")
        guard let user = user else { return }
//        let controller = ProfileCollectionViewController(user: user)
        let controller = NewProfileVC()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }

}

