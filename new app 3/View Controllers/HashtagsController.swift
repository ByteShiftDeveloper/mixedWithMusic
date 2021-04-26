//
//  HashtagsController.swift
//  new app 3
//
//  Created by William Hinson on 6/5/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import AVKit

class HashtagsController: UICollectionViewController {
    
    var posts = [Post]()
    var hashtag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        collectionView.backgroundColor = .white
        collectionView.register(UpdatedPostCollectionCell.self, forCellWithReuseIdentifier: "PostCell")
        
        fetchHashTagPosts()
        
    }
    
    func configureNavigationBar() {
        guard let hashtag = self.hashtag else { return }
        navigationItem.title = hashtag
    }
    
    func fetchHashTagPosts() {
        
        guard let hashtag = self.hashtag else { return }
        
        HASHTAGPOSTREF.child(hashtag).observe(.childAdded) { snapshot in
            let postID = snapshot.key
            
            Service.shared.fetchPost(withPostID: postID) { post in
                self.posts.append(post)
                self.collectionView.reloadData()
            }
        }
    }
}


    
    extension HashtagsController {
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return posts.count
        }
        
         override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! UpdatedPostCollectionCell
            cell.post = posts[indexPath.row]
//            cell.delegate = self
//            handleHashTagTapped(forCell: cell)
            return cell
        }
        
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let controller = SelectedPostController(post: posts[indexPath.row])
            navigationController?.pushViewController(controller, animated: true)

        }
    }

    //extension FeedController: UICollectionViewDelegateFlowLayout {
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //    }
    //
    //}

    extension HashtagsController: UICollectionViewDelegateFlowLayout {

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            var height : CGFloat = 120
                  let post = posts[indexPath.row]

                  height += textHeight(text: post.text)

                  if post.picture != ""{
                      height += 317
                  }

                  return CGSize(width: view.frame.width, height: height)
        }
    }



    extension HashtagsController {
        func textHeight(text : String) -> CGFloat{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: CGFloat.greatestFiniteMagnitude))
            label.text = text
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 17)
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.sizeToFit()
            return label.frame.height
        }
    }

extension HashtagsController: PostDelegate {
    
    func handleSongTap(_ cell: UpdatedPostCollectionCell) {
        
    }
    func handleActionSheet(_ cell: UpdatedPostCollectionCell) {
        print("tapped")
    }
    
    func handlePlayTapped(_ cell: UpdatedPostCollectionCell) {
        guard let post = cell.post else { return }
        guard let videoURL = URL(string: post.video) else { return }
        let player = AVPlayer(url: videoURL)
        let videoPlayer = AVPlayerViewController()
        videoPlayer.player = player
        self.present(videoPlayer, animated: true) {
            player.play()
        }
    }
    
    func handleRepostTapped(_ cell: UpdatedPostCollectionCell) {
        print("Repost clicked")
    }
    
    func handleImageZoom(_ cell: UpdatedPostCollectionCell) {
        print("Image is being tapped")

    }
    
    func handleShareTap(_ cell: UpdatedPostCollectionCell) {
        print("Tapped")
    }
    
    func handleNameTap(_ cell: UpdatedPostCollectionCell) {
//        guard let user = cell.post?.user else { return }
//        let controller = ProfileCollectionViewController(user: user)
//        navigationController?.pushViewController(controller, animated: true)

    }
    
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUserByUserName(withUsername: username) { user in
            
        }
    }
    
        func handleLikeTap(_ cell: UpdatedPostCollectionCell) {
            guard let post = cell.post else { return }
            
            Service.shared.likePost(post: post) { (err, ref) in
                cell.post?.didLike.toggle()
                let likes = post.didLike ? post.likes - 1 : post.likes + 1
                cell.post?.likes = likes
                
                //only upload notification if post is being liked
                guard !post.didLike else { return }
                NotificationService.shared.uploadNotification(type: .like, post: post)
            }
            
        }
        
        func handleCommentTap(_ cell: UpdatedPostCollectionCell) {
           guard let post = cell.post else { return }
            let controller = PostReplyController(user: post.user, post: post)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
        
        func handleProfileImageTapped(_ cell: UpdatedPostCollectionCell) {
            guard let user = cell.post?.user else { return }
            let controller = ProfileCollectionViewController(user: user)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
