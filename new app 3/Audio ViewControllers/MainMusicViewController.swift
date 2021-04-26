//
//  MainMusicViewController.swift
//  new app 3
//
//  Created by William Hinson on 2/21/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

class MainMusicViewController: UITableViewController, UICollectionViewDelegate,  UICollectionViewDataSource  {
    
    var selectedIndexPath: IndexPath!

    var currentIndexSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.reloadData()

    }
    
    func showSongs() {
        
    }
    
    
    
//    func observeSongs() {
//
//        let ref = Database.database().reference().child("audio")
//
//        var tempPosts = []
//
//        ref.observe(.value) { (snapshot) in
//            for child in snapshot.children {
//                if let childSnapshot = child as? DataSnapshot,
//                    let dict = childSnapshot as? [String:Any],
//                           let author = dict["uploadBy"] as? [String:Any],
//                           let uid = author["uid"] as? String,
//                           let fullname = author["username"] as? String,
//                           let photoURL = author["photoURL"] as? String,
//                           let url = URL (string:photoURL),
//
//                           let timestamp = dict["timestampt"] as? Double {
//
//                           let coverImage = dict["coverImage"] as? String ?? ""
//                           let audioURL = dict["AudioUrl"] as? String ?? ""
//                           let trackTitle = dict["trackTitle"] as? String ?? ""
//
//
//                           let userProfile = UserProfile(uid: uid, fullname: fullname, photoURL: url)
//                    return SongPost(id: childSnapshot.key, author: userProfile, title: trackTitle, coverImage: coverImage, audio: audioURL, timestamp: timestamp)
//
//                       }
//            }
//        }
//
//
//    }
    
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         if section == 0 {
//                   return 1
//               } else if section == 1 {
//                   return 1
//               } else if section == 2 {
//                   return 1
//               } else {
//               return 1
//            }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell", for: indexPath) as! GenresTableViewCell
            currentIndexSection = indexPath.section
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
            return cell
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedArtistsCollectionViewTableViewCell", for: indexPath) as! FeaturedArtistsCollectionViewTableViewCell
            currentIndexSection = indexPath.section
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
            return cell
        } else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewReleasesCollectionViewTableViewCell", for: indexPath) as! NewReleasesCollectionViewTableViewCell
            currentIndexSection = indexPath.section
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SomthingElseCollectionViewTableViewCell", for: indexPath) as! SomthingElseCollectionViewTableViewCell
            currentIndexSection = indexPath.section
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            return cell
        }
    }
     
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    //MARK:- collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if currentIndexSection == 0{

            let cell:GenresInsideTableViewCellCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "genresCollectionViewCell", for: indexPath) as! GenresInsideTableViewCellCollectionViewCell

            return cell
        } else if currentIndexSection == 1 {

        let cell:FeaturedArtistsInsideTableViewCellCollectionViewCell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedArtistsInsideTableViewCellCollectionViewCell", for: indexPath) as! FeaturedArtistsInsideTableViewCellCollectionViewCell

        
        return cell
        } else if currentIndexSection == 2 {
            let cell:NewReleasesInsideTableViewCellCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewReleasesInsideTableViewCellCollectionViewCell", for: indexPath) as! NewReleasesInsideTableViewCellCollectionViewCell

            
            return cell
        } else {
            let cell:SomethingElseInsideTableViewCellCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SomethingElseInsideTableViewCellCollectionViewCell", for: indexPath) as! SomethingElseInsideTableViewCellCollectionViewCell

            
            return cell
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cview =  scrollView as? UICollectionView{
            currentIndexSection = cview.tag
        }
    }
}
   
