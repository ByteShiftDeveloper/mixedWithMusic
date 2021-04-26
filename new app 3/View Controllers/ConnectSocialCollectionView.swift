//
//  ConnectSocialCollectionView.swift
//  new app 3
//
//  Created by William Hinson on 3/24/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import Firebase

private let reuseIdentifier = "InstagramActionCell"
private let reuseIdentifier2 = "TwitterActionCell"
private let reuseIdentifier3 = "SpotifyActionCell"
private let reuseIdentifier4 = "SoundCloudActionCell"
private let reuseIdentifier5 = "SocialsSaveButton"

class ConnectSocialCollectionView: UICollectionViewController {
    
    private var user: User
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let urls = [1,2,3,4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.register(InstagramActionCell.self, forCellReuseIdentifier: reuseIdentifier)
//        collectionView.register(TwitterActionCell.self, forCellReuseIdentifier: reuseIdentifier2)
//        collectionView.register(SpotifyActionCell.self, forCellReuseIdentifier: reuseIdentifier3)
//        collectionView.register(SoundCloudActionCell.self, forCellReuseIdentifier: reuseIdentifier4)
        
        collectionView.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        
        
        collectionView.register(InstagramActionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(TwitterActionCell.self, forCellWithReuseIdentifier: reuseIdentifier2)
        collectionView.register(SpotifyActionCell.self, forCellWithReuseIdentifier: reuseIdentifier3)
        collectionView.register(SoundCloudActionCell.self, forCellWithReuseIdentifier: reuseIdentifier4)
        collectionView.register(SocialsSaveButton.self, forCellWithReuseIdentifier: reuseIdentifier5)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return urls.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as! TwitterActionCell
            cell.user = user
//                    cell.titleLabel.delegate = self
            return cell
        } else   if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier3, for: indexPath) as! SpotifyActionCell
            cell.user = user
//                    cell.titleLabel.delegate = self
            return cell
        } else   if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier4, for: indexPath) as! SoundCloudActionCell
            cell.user = user
//                    cell.titleLabel.delegate = self
            return cell
        }  else   if indexPath.section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier5, for: indexPath) as! SocialsSaveButton
            cell.delegate = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InstagramActionCell
        cell.user = user
//                cell.titleLabel.delegate = self
        return cell
    }
}

extension ConnectSocialCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
              
        return CGSize(width: view.frame.width, height: 120)
    }
}

extension ConnectSocialCollectionView: SocialsSaveButtonDelegate {
    func handleTap(_ cell: SocialsSaveButton) {
        
        self.dismiss(animated: true) {
            print("Button is being tapped")
            guard let uid = Auth.auth().currentUser?.uid else { return }

            let cell1 = self.collectionView.cellForItem(at: [0,0]) as! InstagramActionCell
            let cell2 = self.collectionView.cellForItem(at: [1,0]) as! TwitterActionCell
            let cell3 = self.collectionView.cellForItem(at: [2,0]) as! SpotifyActionCell
            let cell4 = self.collectionView.cellForItem(at: [3,0]) as! SoundCloudActionCell

            guard let igInfo = cell1.titleLabel.text else { return }
            guard let twitterInfo = cell2.titleLabel.text else { return }
            guard let spotifyInfo = cell3.titleLabel.text else { return }
            guard let soundcloudInfo = cell4.titleLabel.text else { return }

            let values = ["igInfo": igInfo,
                          "twitterInfo": twitterInfo,
                          "spotifyInfo": spotifyInfo,
                          "soundcloudInfo": soundcloudInfo] as [String:Any]

            let ref = REF_USERS.child(uid)
            ref.updateChildValues(values) { (err, ref) in
        }

        }
    }
}
