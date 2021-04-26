//
//  AlbumSongArtistTableViewController.swift
//  audioPlayerApp
//
//  Created by William Hinson on 2/15/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import AVFoundation

class AlbumSongArtistTableViewController: UITableViewController, UICollectionViewDelegate,  UICollectionViewDataSource, UISearchBarDelegate {
    
    var selectedIndexPath: IndexPath!
    
    
    var songData = [String]()
    
    var songs = [SongPost]()
    
    var song:SongPost?
    
    var users = [User]()
    
    var artist: Users?
    
    var searchBar = UISearchBar()
    
    var genreImages = ["Alternative-1","Blues-1","Children's Music","Christian & Gospel","Classical","Comedy","Country","Dance","EDM","Electronic","French Pop","German Folk","Rap-1","Holiday","Indie Pop","Industrial","Instrumental","J-Pop","Jazz","K-Pop","Latin","New Age","Opera","Pop","Soul","Reggae","Rock","Songwritter","Soundtrack","Tejano","Vocal","World"]
    
    
    var currentIndexSection = 0
    
    static var player : AVPlayer = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.reloadData()
        
//        grabAudioUpload()
        creatSearchBar()
        fetchUser()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let tabBar = self.tabBarController?.tabBar else { return }
        
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor.black
        tabBar.isTranslucent = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let tabBar = self.tabBarController?.tabBar else { return }
        
        tabBar.tintColor = UIColor.black
        tabBar.barTintColor = UIColor.white
        tabBar.isTranslucent = false
        
    }
    
    func creatSearchBar() {
//        let searchBar = UISearchBar()
//        searchBar.showsCancelButton = false
//        searchBar.delegate = self
//
//        self.navigationItem.titleView = searchBar
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
//        searchBar.barTintColor = .red
//        searchBar.tintColor = .blue
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchTableViewController") as? SearchTableViewController
        let navigationcontroller = UINavigationController(rootViewController: vc!)
        navigationcontroller.modalPresentationStyle = .fullScreen
        present(navigationcontroller, animated: false, completion: nil)
//
//           self.present(UINavigationController(rootViewController: SearchTableViewController()), animated: false, completion: nil)
           searchBar.setShowsCancelButton(false, animated: true)
           return false
       }
    
    
//    func grabAudioUpload() {
//        let ref = Database.database().reference().child("audio")
//
//        ref.observe(.value) { (snapshot) in
//
//            //            print(snapshot)
//
//            for child in snapshot.children {
//                if let childSnapshot = child as? DataSnapshot,
//                    let dict = childSnapshot.value as? [String:Any],
//                    let author = dict["uploadBy"] as? [String:Any],
//                    let uid = author["uid"] as? String,
//                    let fullname = author["username"] as? String,
//                    //let photoURL = author["photoURL"] as? String,
//                    let trackTitle = dict["trackTitle"] as? String,
//                    let url = URL (string:"www.google.com"),
//                    let coverImageURL = dict["coverImage"] as? String,
//                    let imageURL = URL (string:coverImageURL),
//                    let audios = dict["AudioUrl"] as? [[String:Any]],
//                    //let songURL = URL (string:audioURL),
//
//                    let timestamp = dict["timestampt"] as? Double {
//
//                    var audioNames  = [String]()
//                    var audioUrls  = [URL]()
//                    for audio in audios{
//                        let audioName = audio.first?.key
//                        let audioUrl = audio.first?.value as? String
//                        let songURL = URL (string:audioUrl!)
//
//                        audioNames.append(audioName!)
//                        audioUrls.append(songURL!)
//                    }
//
//                    let userProfile = UserProfile(uid: uid, fullname: fullname, photoURL: url)
//                    let song = SongPost(id: childSnapshot.key, author: userProfile, title: trackTitle, coverImage: imageURL, audioUrl: audioUrls , audioName: audioNames , timestamp: timestamp)
//
//                    self.songs.removeAll(where: {$0.id == childSnapshot.key})
//
//                    self.songs.append(song)
//                    //
//
//
//                    self.tableView.reloadData()
//                }
//            }
//        }
//
//    }
    
   func fetchUser(){
   
       Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
           print(snapshot)
           
           guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
           
           let uid = snapshot.key
           
           let user = User(uid: uid, dictionary: dictionary)
           
           self.users.append(user)
           
           self.tableView.reloadData()
           
       }
   
   }

    
    
    
    
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
            
            cell.gCollectionView.reloadData()
            
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
            
            cell.nrCollectionView.reloadData()
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SomthingElseCollectionViewTableViewCell", for: indexPath) as! SomthingElseCollectionViewTableViewCell
            currentIndexSection = indexPath.section
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180
        } else {
            
            return 300
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if indexPath.row == 0 {
        //            let vc1 = storyboard?.instantiateViewController(withIdentifier: "GenreHeaderViewTableViewController") as? GenreHeaderViewTableViewController
        //
        //            self.present(vc1!, animated: true, completion: nil)
        //        }
    }
    
    //MARK:- collection view delegate
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentIndexSection == 0 {
            
            return genreImages.count
            
        } else if currentIndexSection == 1 {
            
            return users.count
            
        } else if currentIndexSection == 2 {
            return songs.count
        } else {
            return songs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if currentIndexSection == 0{
            
            let cell:GenresInsideTableViewCellCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "genresCollectionViewCell", for: indexPath) as! GenresInsideTableViewCellCollectionViewCell
            
            cell.trackImage.image = UIImage(named: genreImages[indexPath.row])
            ////
            //            cell.set(songPost: self.songs[indexPath.row])
            //            cell.trackName.text = song?.title
            //            cell.trackImage.image = song?.coverImage
            collectionView.tag = 0
            
            
            return cell
        } else if currentIndexSection == 1 {
            
            let cell:FeaturedArtistsInsideTableViewCellCollectionViewCell =
                collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedArtistsInsideTableViewCellCollectionViewCell", for: indexPath) as! FeaturedArtistsInsideTableViewCellCollectionViewCell
            
            
            cell.user = users[indexPath.row]
            
            collectionView.tag = 1
            
            
            
            return cell
        } else if currentIndexSection == 2 {
            let cell:NewReleasesInsideTableViewCellCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewReleasesInsideTableViewCellCollectionViewCell", for: indexPath) as! NewReleasesInsideTableViewCellCollectionViewCell
            
            //            let song1: SongPost
            
            cell.set(song: self.songs[indexPath.row])
            //            cell.trackTitle.text = song?.title
            collectionView.tag = 2
            
            return cell
        } else {
            let cell:SomethingElseInsideTableViewCellCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SomethingElseInsideTableViewCellCollectionViewCell", for: indexPath) as! SomethingElseInsideTableViewCellCollectionViewCell
            
            collectionView.tag = 3
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if currentIndexSection == 0 {
            
            //            let vc1 = storyboard?.instantiateViewController(withIdentifier: "GenreHeaderViewTableViewController") as? GenreHeaderViewTableViewController
            //
            //            self.present(vc1!, animated: true, completion: nil)
            
            
//            print(currentIndexSection)
            
//        } else {
            
            //        let vc = storyboard?.instantiateViewController(identifier: "HeaderViewTableViewController") as? HeaderViewTableViewController
            //        vc?.song = songs[indexPath.row]
            ////        vc?.song1 = songs
            //        self.present(vc!, animated: true, completion: nil)
            
//        }
        
        if collectionView.tag == 0{
            
            let vc1 = storyboard?.instantiateViewController(withIdentifier: "GenreHeaderViewTableViewController") as? GenreHeaderViewTableViewController
            
            vc1?.genreName = genreImages[indexPath.row]
            vc1?.genreImage = UIImage(named: genreImages[indexPath.row])!
                
            navigationController?.pushViewController(vc1!, animated: true)

            
            
        } else if collectionView.tag == 1 {
            
            guard let user = users[indexPath.row] as? User else { return }
            let controller = ProfileCollectionViewController(user: user)
            navigationController?.pushViewController(controller, animated: true)
        
        
        }else if collectionView.tag == 2{
            let vc = storyboard?.instantiateViewController(identifier: "HeaderViewTableViewController") as? HeaderViewTableViewController
            vc?.song = songs[indexPath.row]
            //        vc?.song1 = songs
//           let navigationcontroller = UINavigationController(rootViewController: vc!)
//            navigationcontroller.modalPresentationStyle = .fullScreen
//            present(navigationcontroller, animated: true, completion: nil)
            navigationController?.pushViewController(vc!, animated: true)

        }
        
        
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cview =  scrollView as? UICollectionView{
            currentIndexSection = cview.tag
        }
    }
}

