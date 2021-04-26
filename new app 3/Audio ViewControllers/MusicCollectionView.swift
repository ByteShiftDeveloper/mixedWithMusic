//
//  MusicCollectionView.swift
//  audioPlayerApp
//
//  Created by William Hinson on 1/29/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit

class MusicCollectionView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var featuredArtistsCollectionView: UICollectionView!
    
    @IBOutlet weak var newReleases: UICollectionView!
    
    var imageArray = ["Alternative","Blues","Rap","Ariana","Box"]
    
    var featuredArtistArray = ["Ariana","Box","Ariana","Box"]
    
    var newReleasesArray = ["Ariana","Box","Alternative","Blues","Rap"]
    
    var  selectedIndexPath: IndexPath!
    
    struct Storyboard {
        static let showDetailSegue = "ShowDetail"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        
        featuredArtistsCollectionView.delegate = self
        featuredArtistsCollectionView.dataSource = self
        
        newReleases.dataSource = self
        newReleases.delegate = self
        

//         view.setCrazyBackground(colorOne: Colors.black, colorTwo: Colors.lightBlakc, colorThree: Colors.darkGray, colorFour: Colors.darkGray)
//
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionVIew{
            return imageArray.count
        } else if collectionView == self.featuredArtistsCollectionView {
        return featuredArtistArray.count
        }
        else {
            return newReleasesArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionVIew{
            
            let cell:GenreCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as! GenreCollectionViewCell
        
        cell.genreImage.image = UIImage(named: imageArray[indexPath.row])
            
            return cell
        } else if collectionView == self.featuredArtistsCollectionView {
            
        let cell:FeaturedArtistsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedArtistsCollectionViewCell", for: indexPath) as! FeaturedArtistsCollectionViewCell
        
        cell.featuredArtist.image = UIImage(named: featuredArtistArray[indexPath.row])
        
        return cell
        } else {
            let cell:NewReleasesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewReleasesCollectionViewCell", for: indexPath) as! NewReleasesCollectionViewCell
                   
                   cell.newReleases.image = UIImage(named: newReleasesArray[indexPath.row])
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionVIew {
            let image = UIImage(named: imageArray[indexPath.row])
            
            self.selectedIndexPath = indexPath
            self.performSegue(withIdentifier: Storyboard.showDetailSegue, sender: image)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showDetailSegue {
            let detailTVC = segue.destination as! HeaderViewTableViewController
          
        }
        
    }
    
}
