//
//  PostService.swift
//  new app 3
//
//  Created by William Hinson on 5/9/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//


import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct Service {
    static let shared = Service()
    
    var postCell : UpdatedPostCollectionCell?
    
    func fetchUserPost(forUser user: User, completion: @escaping([Post]) -> Void) {
        var posts = [Post]()
        USER_POSTS.child(user.uid).observe(.childAdded) { snapshot in
            let postID = snapshot.key
            
            POSTS_REF.child(postID).observeSingleEvent(of: .value) { snapshot in
                print(snapshot)
                guard let dictionary = snapshot.value as? [String:Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let post = Post(postID: postID, user: user, dictionary: dictionary)
                    posts.append(post)
                    completion(posts)
                }
                
            }
        }
    }
    
    func fetchUserUploads(forUser user: User, completion: @escaping([SongPost]) -> Void) {
        var songs = [SongPost]()
        
        USER_UPLOADS.child(user.uid).observe(.childAdded) { snapshot in
            let uploadID = snapshot.key
            
            UPLOADS_REF.child(uploadID).observeSingleEvent(of: .value) { snapshot in
                print("audio is \(snapshot)")
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                
                
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let dict = childSnapshot.value as? [String:Any],
                       //                          let author = dict["uploadBy"] as? [String:Any],
                       let uid = dict["uid"] as? String,
                       let fullname = dict["username"] as? String,
                       let photoURL = dict["photoURL"] as? String,
                       let trackTitle = dict["trackTitle"] as? String,
                       let url = URL (string:photoURL),
                       let likes = dictionary["likes"] as? Int,
                       let coverImageURL = dict["coverImage"] as? String,
                       let imageURL = URL (string:coverImageURL),
                       let audios = dict["AudioUrl"] as? [[String:Any]],
                       let streams = dictionary["streams"] as? Int,

                       //let songURL = URL (string:audioURL),
                       
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
                            let song = SongPost(id: childSnapshot.key, author: user, title: trackTitle, coverImage: imageURL, audioUrl: audioUrls , audioName: audioNames, likes: likes , timestamp: timestamp, streams: streams)
                            songs.append(song)
                            completion(songs)
                            
                        }
                    }
                }
            }
            
            
        }
        
    }
    
    
    func fetchGenrePost(forGenre genre: String, completion: @escaping([SongPost]) -> Void) {
        var songs = [SongPost]()
        
        Database.database().reference().child("audio-by-genres").child(genre).observe(.childAdded) { snapshot in
            let uploadID = snapshot.key
            
            UPLOADS_REF.child(uploadID).observeSingleEvent(of: .value) { snapshot in
                print("audio is \(snapshot)")
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                
                
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let dict = childSnapshot.value as? [String:Any],
                       //                          let author = dict["uploadBy"] as? [String:Any],
                       let uid = dict["uid"] as? String,
                       let fullname = dict["username"] as? String,
                       let photoURL = dict["photoURL"] as? String,
                       let trackTitle = dict["trackTitle"] as? String,
                       let url = URL (string:photoURL),
                       let coverImageURL = dict["coverImage"] as? String,
                       let imageURL = URL (string:coverImageURL),
                       let likes = dictionary["likes"] as? Int,
                       let streams = dictionary["streams"] as? Int,
                       let audios = dict["AudioUrl"] as? [[String:Any]],
                       //let songURL = URL (string:audioURL),
                       
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
                            let song = SongPost(id: childSnapshot.key, author: user, title: trackTitle, coverImage: imageURL, audioUrl: audioUrls , audioName: audioNames, likes: likes , timestamp: timestamp, streams: streams)
                            songs.append(song)
                            completion(songs)
                            
                        }
                    }
                }
            }
            
            
        }
        
    }
    
    
    func getIDs(completion: @escaping([String]) -> Void) {
        var posts = [Post]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        USER_FOLLOWING_REF.child(uid).observe(.value) { snapshot in
            let followinguid = snapshot.key
            let ids = snapshot.value as? [String: Any]
            var idsArr : [String] = []
            if let ids = ids?.keys  {
                for i in ids {
                    idsArr.append(i)
                }
            }
            idsArr.append(uid)
            completion(idsArr)
            
        }
        
    }
    
    func fetchPostIds(userIds : [String],completion: @escaping([String]) -> Void){
        var count = 0
        var idsArr : [String] = []

        for i in userIds{
            USER_POSTS.child(i).observe(.value) { snapshot in
                count += 1
                let postID = snapshot.key
                
                let ids = snapshot.value as? [String: Any]
                if let ids = ids?.keys  {
                    for i in ids {
                        idsArr.append(i)
                    }
                }
                
                if count == userIds.count{
                    completion(idsArr)
                }
            }
        }
    }
    
    
    func fetchPostsNew(completion: @escaping([Post]) -> Void){
        getIDs { userIds in
            fetchPostIds(userIds: userIds) { (postIds) in
                //                var i = 0
                var postsArr : [Post] = []
                for id in postIds{
                    self.fetchPost(withPostID: id) { post in
                        postsArr.append(post)
                        if postsArr.count == postIds.count{
                            completion(postsArr)
                        }
                    }
                }
            }
        }
    }
  
    
    func FetchPosts(completion: @escaping([Post]) -> Void) {
        var posts = [Post]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
                
        USER_FOLLOWING_REF.child(currentUid).observe(.childAdded) { snapshot in
            let followingUid = snapshot.key
            
            USER_POSTS.child(followingUid).observe(.childAdded) { snapshot in
                let postID = snapshot.key
                
                self.fetchPost(withPostID: postID) { post in
                    posts.append(post)
                    completion(posts)
                }
            }
        }
        
        USER_POSTS.child(currentUid).observe(.childAdded) { snapshot in
            let postID = snapshot.key
            
            self.fetchPost(withPostID: postID) { post in
                posts.append(post)
                completion(posts)
            }
        }
    }
    
    func fetchPost(withPostID postID: String, completion: @escaping(Post) -> Void) {
        POSTS_REF.child(postID).observeSingleEvent(of: .value) { snapshot in
            print(snapshot)
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let post = Post(postID: postID, user: user, dictionary: dictionary)
                completion(post)
            }
        }
    }
    
    func fetchUpload(withSongID songID: String, completion: @escaping(SongPost) -> Void) {
        
        UPLOADS_REF.child(songID).observeSingleEvent(of: .value) { snapshot in
                  print("THE AUDIO SNAPSHOT IS \(snapshot)")
            
                      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                                          guard let uid = dictionary["uid"] as? String else { return }
                                          guard let photoURL = dictionary["photoURL"] as? String else { return }
                                          guard let trackTitle = dictionary["trackTitle"] as? String else { return }
                                          guard let coverImageURL = dictionary["coverImage"] as? String else { return }
                                          guard let imageURL = URL (string:coverImageURL) else { return }
                                          guard let audios = dictionary["AudioUrl"] as? [[String:Any]] else { return }
                                          guard let likes = dictionary["likes"] as? Int else { return }
                                          guard let streams = dictionary["streams"] as? Int else { return }
            
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
                                    
                                   
                                    
                                    completion(song)
                }
            }
        }
    }
    
    func fetchRepost(withPostID postID: String, completion: @escaping(Post) -> Void) {
        REPOSTED_POST.child(postID).observeSingleEvent(of: .value) { snapshot in
            print("Repost snapshot is \(snapshot)")
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            
            
            UserService.shared.fetchUser(uid: uid) { user in
                let post = Post(postID: postID, user: user, dictionary: dictionary)
                completion(post)
            }
        }
    }
    
    //
    
    
    func fetchLikes(forUser user: User, completion: @escaping([Post]) -> Void) {
        var posts = [Post]()
        
        USER_LIKES_REF.child(user.uid).observe(.childAdded) { snapshot in
            let postID = snapshot.key
            self.fetchPost(withPostID: postID) { likedpost in
                var post = likedpost
                post.didLike = true
                posts.append(post)
                completion(posts)
            }
            
        }
    }
    
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_FOLLOWING_REF.child(currentUid).updateChildValues([uid: 1]) { (err, ref) in
            USER_FOLLOWER_REF.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_FOLLOWING_REF.child(currentUid).child(uid).removeValue { (err, ref) in
            USER_FOLLOWER_REF.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_FOLLOWING_REF.child(currentUid).child(uid).observe(.value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping(UserRelationStats) -> Void) {
        USER_FOLLOWER_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            USER_FOLLOWING_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
                
            }
            
        }
    }
    
    func fetchComments(forPost post: Post, completion: @escaping([Post]) -> Void) {
        var posts = [Post]()
        
        REF_POST_COMMENTS.child(post.postID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
            
            guard let uid = dictionary["uid"] as? String else { return }
            let postID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let post = Post(postID: postID, user: user, dictionary: dictionary)
                posts.append(post)
                completion(posts)
            }
        }
    }
    
    func fetchGigs(completion: @escaping([Gigs]) -> Void) {
        var gigs = [Gigs]()

        GIGS_REF.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let gigID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let gig = Gigs(GigId: gigID, user: user, dictionary: dictionary)
                gigs.append(gig)
                completion(gigs)
            }
        }
        
    }
    
    func fetchGig(forGig gigID: String, completion: @escaping(Gigs) -> Void) {

        GIGS_REF.child(gigID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let gig = Gigs(GigId: gigID, user: user, dictionary: dictionary)
                completion(gig)
            }
        }
    }
    
    
    
    
    func likePost(post: Post, completion: @escaping(DatabaseCompletion)) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = post.didLike ? post.likes - 1 : post.likes + 1
        POSTS_REF.child(post.postID).child("likes").setValue(likes)
        
        if post.didLike {
            //unlike post
            USER_LIKES_REF.child(uid).child(post.postID).removeValue { (err, ref) in
                POST_LIKES_REF.child(post.postID).removeValue(completionBlock: completion)
            }
        } else {
            //like post
            USER_LIKES_REF.child(uid).updateChildValues([post.postID: 1]) { (err, ref) in
                POST_LIKES_REF.child(post.postID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
 

    
    func applyToGig(gig: Gigs, completion: @escaping(DatabaseCompletion)) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let applications = gig.didApply ? gig.applications + 0 :  gig.applications + 1
        GIGS_REF.child(gig.GigId).child("applications").setValue(applications)
        
        if gig.didApply {
            //unlike post
            print("nothing")
        } else {
            USER_APPLICATION_REF.child(uid).updateChildValues([gig.GigId: 1]) { (err, ref) in
                GIG_APPLICATIONS_REF.child(gig.GigId).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func likeComment(comment: Comment, completion: @escaping(DatabaseCompletion)) {
//        
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        
//        let likes = comment.didLike ? comment.likes - 1 : comment.likes + 1
//        REF_POST_COMMENTS.child(comment.commentID).child(uid).child("likes").setValue(likes)
//        
//        if post.didLike {
//            //unlike post
//            USER_LIKES_REF.child(uid).child(post.postID).removeValue { (err, ref) in
//                POST_LIKES_REF.child(post.postID).removeValue(completionBlock: completion)
//            }
//        } else {
//            //like post
//            USER_LIKES_REF.child(uid).updateChildValues([post.postID: 1]) { (err, ref) in
//                POST_LIKES_REF.child(post.postID).updateChildValues([uid: 1], withCompletionBlock: completion)
//            }
//        }
    }

    
    func deletePost(post: Post, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        POSTS_REF.child(post.postID).removeValue { (err, ref) in
            USER_POSTS.child(uid).child(post.postID).removeValue(completionBlock: completion)
            POST_LIKES_REF.child(post.postID).removeValue(completionBlock: completion)
            USER_LIKES_REF.child(uid).child(post.postID).removeValue(completionBlock: completion)
        }
        
    }
    
    func deleteAccount(user: User, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).removeValue { (err, ref) in
            REF_USER_USERNAMES.child(uid).removeValue(completionBlock: completion)
        }
    }
    
    
    
    func likeSong(song: SongPost, completion: @escaping(DatabaseCompletion)) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = song.didLike ? song.likes - 1 : song.likes + 1
        UPLOADS_REF.child(song.id).child("likes").setValue(likes)
        
        if song.didLike {
            //unlike post
            USER_SONG_LIKES.child(uid).child(song.id).removeValue { (err, ref) in
                AUDIO_LIKES.child(song.id).removeValue(completionBlock: completion)
            }
        } else {
            //like post
            USER_SONG_LIKES.child(uid).updateChildValues([song.id: 1]) { (err, ref) in
                AUDIO_LIKES.child(song.id).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    
    func checkIfUserLikedPost(_ post: Post, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        USER_LIKES_REF.child(uid).child(post.postID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func checkIfUserAppled(_ gig: Gigs, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        USER_APPLICATION_REF.child(uid).child(gig.GigId).observeSingleEvent(of: .value) { snapshot in
            print("User has applied to gig \(snapshot.exists())")
            completion(snapshot.exists())
        }
    }
    
    func checkIfUserLikedComment(_ comment: Comment, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        USER_LIKES_REF.child(uid).child(comment.commentID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func checkIfUserLikedAudio(_ song: SongPost, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        USER_SONG_LIKES.child(uid).child(song.id).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func signOut(completion: @escaping(Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch let error {
            print(error)
            completion(false)
        }
    }
    
    func uploadPost(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "timestampt": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "text": caption] as [String:Any]
        
        let ref = POSTS_REF.childByAutoId()
        ref.updateChildValues(values) { (err, ref) in
            guard let postID = ref.key else { return }
            USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
        }
    }
    
    func uploadPostWithURL(caption: String, url: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "timestampt": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "url": url,
                      "text": caption] as [String:Any]
        
        let ref = POSTS_REF.childByAutoId()
        ref.updateChildValues(values) { (err, ref) in
            guard let postID = ref.key else { return }
            USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
        }
    }

            
    func uploadPostWithImage(caption: String, postImage: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "timestampt": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "text": caption,
                      "picture": postImage] as [String:Any]
        
        let ref = POSTS_REF.childByAutoId()
        ref.updateChildValues(values) { (err, ref) in
            guard let postID = ref.key else { return }
            USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
        }
    }
    
    func uploadPostWithVideo(caption: String, postvideo: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "timestampt": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "text": caption,
                      "video": postvideo] as [String:Any]
        
        let ref = POSTS_REF.childByAutoId()
        ref.updateChildValues(values) { (err, ref) in
            guard let postID = ref.key else { return }
            USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
        }
    }
    
    func uploadImageOnly( postImage: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "timestampt": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "picture": postImage] as [String:Any]
        
        let ref = POSTS_REF.childByAutoId()
        ref.updateChildValues(values) { (err, ref) in
            guard let postID = ref.key else { return }
            USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
        }
    }
    
    func uploadVideoOnly( postVideo: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "timestampt": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "video": postVideo] as [String:Any]
        
        let ref = POSTS_REF.childByAutoId()
        ref.updateChildValues(values) { (err, ref) in
            guard let postID = ref.key else { return }
            USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
        }
    }
    
    func uploadRepost(caption: String, post: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "timestampt": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "text": caption] as [String:Any]
        
        let ref = POSTS_REF.childByAutoId()
        ref.updateChildValues(values) { (err, ref) in
            guard let postID = ref.key else { return }
            USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
        }
    }
    
    func updateProfileImage(image: UIImage, completion: @escaping(URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let filename = NSUUID().uuidString
        let ref = STORAGE_PROFILE_IMAGES.child(filename)
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                let values = ["photoURL": profileImageUrl]
                
                REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                    completion(url)
                }
            }
        }
    }
    
    func updateHeaderImage(image: UIImage, completion: @escaping(URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let filename = NSUUID().uuidString
        let ref = STORAGE_PROFILE_IMAGES.child(filename)
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            ref.downloadURL { (url, error) in
                guard let headerImageUrl = url?.absoluteString else { return }
                let values = ["headerURL": headerImageUrl]
                
                REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                    completion(url)
                }
            }
        }
    }
}

