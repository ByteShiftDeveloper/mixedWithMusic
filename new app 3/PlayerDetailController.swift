//
//  PlayerDetailController.swift
//  new app 3
//
//  Created by William Hinson on 4/19/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import Firebase
import Kingfisher

protocol PlayerDetailDelegate {
    func handleDismissal()
    func handleMaximizie()
}


class PlayerDetailController: UIView {
    
    let keyWindow = UIApplication.shared.connectedScenes
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows.first
    
    var delegate:PlayerDetailDelegate?
    
    weak var tabController: TabBarController?
    
    var didLike = false
    
    var miniPlayerViewY : CGFloat = 0
    var playerHeight : CGFloat = 0
    var topConstr : CGFloat = 0

    var song: SongPost! {
        
        didSet {
            //playingAudio()
            
            playSong()
            
         
            
            let coverurl = URL(string: song.coverImage.absoluteString)
            coverImage.kf.setImage(with: coverurl)
            miniPlayerView.backgroundColor = coverImage.image?.averageColor
            backgroundColor = coverImage.image?.averageColor
            
            setupNowPlayingInfo()
            
            coverImage.loadImage(with: song.coverImage.absoluteString)
//            backgroundImage.loadImage(with: song.coverImage.absoluteString)
            miniPlayerImage.loadImage(with: song.coverImage.absoluteString)
            
            guard let image = miniPlayerImage.image else { return }
            
            var nowplayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
            
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { (_) -> UIImage in
                return image
            }
            
            nowplayingInfo?[MPMediaItemPropertyArtwork] = artwork
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowplayingInfo
            
            songName.text = song?.audioName[selectedSongIndex]
            artistName.text = song?.author.fullname
            miniPlayerTitle.text = song?.audioName[selectedSongIndex]
            
            print("This song has been played, increase stream count +1")
            increaseStreamCount()
            
            
            
        }
    }
    
    func increaseStreamCount() {
        guard let song = self.song else { return }
        
        let streams = song.streams + 1

        
        UPLOADS_REF.child(song.id).child("streams").setValue(streams)
        
        if song.audioUrl.count == 1 {
            NEW_SINGLE.child(song.id).child("streams").setValue(streams)

        } else if song.audioUrl.count > 1 {
            NEW_ALBUM.child(song.id).child("streams").setValue(streams)

        }
        
        
    }
    
    fileprivate func setupNowPlayingInfo() {
        
        var nowplayingInfo = [String:Any]()
        
        nowplayingInfo[MPMediaItemPropertyTitle] = song.audioName
        nowplayingInfo[MPMediaItemPropertyArtist] = song.author.fullname
        
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowplayingInfo
        
    }
    
      var song2 = [SongPost]()
  
        @IBOutlet weak var downChevron: UIButton!
        var timer:Timer?
        var pauseTimer : Timer = Timer()
//        var player = AVPlayer()

        
        @IBOutlet weak var songName: UILabel!
        @IBOutlet weak var artistName: UILabel!
    
    //MARK: -StackView and MiniPlayer Outlets
    
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var maximizedStackView: UIStackView!
    @IBOutlet weak var miniPlayerImage: UIImageView!
    @IBOutlet weak var miniPlayerTitle: UILabel!
    @IBOutlet weak var miniPlayerPauseButton: UIButton! {
        didSet {
            miniPlayerPauseButton.addTarget(self, action: #selector(handlePlayandPause), for: .touchUpInside)
        }
    }
    
        var trackID: Int = 0
        var toggleState = 1

        var selectedSongIndex = 0
        
        var ref: DatabaseReference?
        var sliderTime : Float = 0.0
        var isDragging : Bool = false
   
    
    var panGesture: UIPanGestureRecognizer!
    
    private lazy var backgroundImage: UIImageView = {
           let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
           backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
           return backgroundImage
       }()
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self ](time) in
            self?.currentTime.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            self?.durationTime.text = durationTime?.toDisplayString()
            
            self?.updateCurrentTimeSlider()
        }
    }
    
    fileprivate func setupLockScreenCurrentTime() {
        var nowplayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        
        guard let currentItem = player.currentItem else { return }
        let durationInSeconds = CMTimeGetSeconds(currentItem.duration)
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        
        nowplayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        player.currentItem?.duration
        nowplayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowplayingInfo
    }

    
    deinit {
        print("Playerdtailsview memeory being reclaimed.....")
    }
    
    func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        self.progressBar.value = Float(percentage)
    }
    
    fileprivate func setupAudioSession() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionErr {
            print("failed", sessionErr)
        }
    }

    
    fileprivate func setupRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            self.playButton.setImage(UIImage(named: "pause 4.png"), for: .normal)
            self.miniPlayerPauseButton.setImage(UIImage(named: "pause 4.png"), for: .normal)
            self.setupElapsedTime()
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.playButton.setImage(UIImage(named: "play 5.png"), for: .normal)
            self.miniPlayerPauseButton.setImage(UIImage(named: "play 5.png"), for: .normal)
            self.setupElapsedTime()
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand .addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.handlePlayandPause()
            return .success
        }
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handleNextTrack()
            return .success
        }
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePreviousTrack()
            return .success
        }
        
    }
    
    var songs = [SongPost]()
    
    @objc func handleNextTrack() {
        print("Successfully tapping next")
        song.audioName.forEach({ print($0.self)})

        
        if song.audioName.count == 0 {
            return
        }
        
        
//        let currentEpisodeIndex = songs.firstIndex { (ep) -> Bool in
//            return self.song.audioName == ep.audioName && self.song.author.fullname == ep.author.fullname
//        }
        
        
        let currentEpisodeIndex = songs.firstIndex { (ep) -> Bool in
            return self.song.audioName == ep.audioName && self.song.author.fullname == ep.author.fullname
        }
        
//
        guard let index = currentEpisodeIndex else { return }

//
//        if selectedSongIndex == song.audioName.count - 1 {
//            player.pause()
//            let songURL = song?.audioUrl[0]
//            songName.text = song?.audioName[0]
//            let playerItem = AVPlayerItem(url: songURL!)
//            player.replaceCurrentItem(with: playerItem)
//            if toggleState == 1{
//                player.play()
//            }
//        } else {
//            player.pause()
//            let songURL = song?.audioUrl[selectedSongIndex + 1]
//            songName.text = song?.audioName[selectedSongIndex + 1]
//            let playerItem = AVPlayerItem(url: songURL!)
//            player.replaceCurrentItem(with: playerItem)
//            if toggleState == 1{
//                player.play()
//            }
//        }

        
        
//        let currentEpisodeIndex = song.firstIndex { (ep) -> Bool in
//            return self.song.audioName == ep.self && self.song.author.fullname == ep.author.fullname
//        }
//
//        guard let index = currentEpisodeIndex else { return }
//
//        let nextSong = songs
//
//        self.song = nextSong
        
//        if selectedSongIndex + 1 < (song?.audioName.count)! {
//             selectedSongIndex += 1
//             player.pause()
//             let songURL = song?.audioUrl[selectedSongIndex]
//
//             print(songURL!)
//             songName.text = song?.audioName[selectedSongIndex]
//             let playerItem = AVPlayerItem(url: songURL!)
//             player.replaceCurrentItem(with: playerItem)
//             if toggleState == 1{
//
//                 player.play()
//
//             }
//
//        }
        
//        let songURL: SongPost
//
//        if selectedSongIndex == songs.count - 1 {
//            songURL = songs[0]
//        } else {
//            songURL = songs[selectedSongIndex + 1]
//        }
//
//        self.song = songURL
        //else
       // if selectedSongIndex == song.audioName.count + 1 {
//            let songURL = song?.audioUrl[selectedSongIndex + 1]
//            print(songURL!)
//            songName.text = song?.audioName[selectedSongIndex]
//            let playerItem = AVPlayerItem(url: songURL!)
//            player.replaceCurrentItem(with: playerItem)
//            if toggleState == 1{
//
//                player.play()
//
//            }
            
        //}
//        songs.forEach({ print($0.audioName)})
//
//        if song.audioName.count == 0 {
//            return
//        }
//
//       let currentSongindex =  songs.firstIndex { (ep) -> Bool in
//        return self.song.audioName == ep.audioName && self.song.author.fullname == ep.author.fullname
//        }
//
//        guard let index = currentSongindex else { return }
//
//        let nextSong = selectedSongIndex += 1
//
//        song?.audioUrl[nextSong]
    }
    
    @objc func handlePreviousTrack() {
        if selectedSongIndex != 0 {
            selectedSongIndex -= 1
            player.pause()
            let songURL = song?.audioUrl[selectedSongIndex]

            print(songURL!)
            songName.text = song?.audioName[selectedSongIndex]
            let playerItem = AVPlayerItem(url: songURL!)
            player.replaceCurrentItem(with: playerItem)
            if toggleState == 1{

                player.play()

            }
        } else if selectedSongIndex == 0 {
            player.pause()
            let songURL = song?.audioUrl[selectedSongIndex]
            songName.text = song?.audioName[selectedSongIndex]
            let playerItem = AVPlayerItem(url: songURL!)
            player.replaceCurrentItem(with: playerItem)
            if toggleState == 1{

                player.play()

            }
        }
    }
//
            @IBAction func nextButton(_ sender: Any) {
    
//                if selectedSongIndex + 1 < (song?.audioName.count)! {
//                    selectedSongIndex += 1
//                    player.pause()
//                    let songURL = song?.audioUrl[selectedSongIndex]
//
//                    print(songURL!)
//                    songName.text = song?.audioName[selectedSongIndex]
//                    let playerItem = AVPlayerItem(url: songURL!)
//                    player.replaceCurrentItem(with: playerItem)
//                    if toggleState == 1{
//
//                        player.play()
//
//                    }
//
//                }
                
                if selectedSongIndex == (song.audioName.count) - 1 {
//                    player.pause()
                    let songURL = song?.audioUrl[0]
                    songName.text = song?.audioName[0]
                    let playerItem = AVPlayerItem(url: songURL!)
                    player.replaceCurrentItem(with: playerItem)
                    if toggleState == 1{

                        player.pause()
                        playButton.setImage(UIImage(named: "play 5.png"), for: .normal)
                        self.miniPlayerPauseButton.setImage(UIImage(named: "play 5.png"), for: .normal)
                        shrinkSongCoverImageView()

                    }
                } else {
                    selectedSongIndex += 1
                  player.pause()
                  let songURL = song?.audioUrl[selectedSongIndex]

                  print(songURL!)
                  songName.text = song?.audioName[selectedSongIndex]
                  let playerItem = AVPlayerItem(url: songURL!)
                  player.replaceCurrentItem(with: playerItem)
                  if toggleState == 1{

                      player.play()
          //
                  }
                }
            }
//
            @IBAction func backButton(_ sender: Any) {
    
                if selectedSongIndex != 0 {
                    selectedSongIndex -= 1
                    player.pause()
                    let songURL = song?.audioUrl[selectedSongIndex]

                    print(songURL!)
                    songName.text = song?.audioName[selectedSongIndex]
                    let playerItem = AVPlayerItem(url: songURL!)
                    player.replaceCurrentItem(with: playerItem)
                    if toggleState == 1{

                        player.play()

                    }
                } else if selectedSongIndex == 0 {
                    player.pause()
                    let songURL = song?.audioUrl[selectedSongIndex]
                    songName.text = song?.audioName[selectedSongIndex]
                    let playerItem = AVPlayerItem(url: songURL!)
                    player.replaceCurrentItem(with: playerItem)
                    if toggleState == 1{

                        player.play()

                    }
                }
            }

    
    fileprivate func setupElapsedTime() {
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
    }

    
    fileprivate func observeBoundaryTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
        //player has a refernce to self
        //self has a refernce to player
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            [weak self] in
            print("Episode started playing....")
            self?.enlargeSongCoverImageView()
            self?.setupLockScreenDuration()
        }
    }
    
    fileprivate func setupLockScreenDuration() {
        guard let duration = player.currentItem?.duration else { return }
        
        let durationSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAudioSession()
        
        setupRemoteControl()
        
        observePlayerCurrentTime()
        
        observeBoundaryTime()
    
        self.insertSubview(backgroundImage, at: 0)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        miniPlayerView.addGestureRecognizer(panGesture)

        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismessalPan)))
//
//        setupRemoteControll()
//
//        setupNowPlayingInfo()
    }
    
    @objc func handleTapMaximize() {
//      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "maximize"), object: nil)
//        delegate?.handleMaximizie()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        appDelegate.addPlayerView(song: nil)

    }
    
//    let popupLabel: UILabel = {
//        let label = UILabel()
//        label.text = "SUCCESS"
//        label.textColor = .black
//        return label
//    }()
//    
//    var popup:UIView!
//    func showAlert() {
//      // customise your view
//      popup = UIView(frame: CGRect(x: 100, y: 200, width: 200, height: 200))
//        popup.backgroundColor = .lightGray
//    
//        
//      // show on screen
//      self.addSubview(popup)
//
//        
//        popup.addSubview(popupLabel)
//        popupLabel.centerX(inView: popup)
//
//      // set the timer
//        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
//    }
//
//    @objc func dismissAlert(){
//      // Dismiss the view from here
//      popup.removeFromSuperview()
//    }
    
    //MARK: -PanGesture
    
    @objc func handleDismessalPan(gesture: UIPanGestureRecognizer) {
        print("maximizeStackView Dismisall")
        
        if gesture.state == .changed {
            let translation = gesture.translation(in: superview)
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: superview)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                let playerDetail = PlayerDetailController()
                self.transform = .identity
                
                if translation.y > 50 {
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate

                    appDelegate.dismissPlayerView()
//                    self.delegate?.handleDismissal()

                }
            })
        }
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer ) {
//        print("panning")
       if gesture.state == .changed {
            panChagned(gesture: gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }
    
    func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
              let velocity = gesture.velocity(in: self.superview)
              UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.transform = .identity
                
                
            if translation.y < -200 || velocity.y < -500 {
//            self.delegate?.handleMaximizie()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate

                appDelegate.addPlayerView(song: nil)
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//            appDelegate.dismissPlayerView()
            self.miniPlayerView.alpha = 1
            self.maximizedStackView.alpha = 0
            
            appDelegate.bottomAnchorConstraint?.constant = -(appDelegate.height ?? 0)
            appDelegate.topAnchor?.constant = self.miniPlayerViewY
            }
        })
    }
    
    func panChagned(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
//        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
          
        print("translation :\(-translation.y/200)")
        if translation.y < 0{
        
            self.sendSubviewToBack(self.maximizedStackView)
            self.miniPlayerView.alpha = 1 + translation.y / 200
            self.maximizedStackView.alpha = -translation.y / 200
            

        
        print("frame:\(self.miniPlayerViewY) , height:\(self.frame.height)")
            
            
            
//        self.frame = CGRect(x: 0, y: self.miniPlayerViewY + translation.y, width: self.frame.width, height: self.frame.height - (translation.y))
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

//        appDelegate.addPlayerView(song: self.song)
            print("bottom anchor :\(appDelegate.bottomAnchorConstraint?.constant)")
            appDelegate.topAnchor?.constant = topConstr + translation.y
//            appDelegate.bottomAnchorConstraint?.constant = -86
            
        }
    }
    
  //MARK: -AVPlayer
    
    fileprivate func playSong() {
        
        guard let songURL = song?.audioUrl[selectedSongIndex] else { return }
        

//        let url = URL(string: song?.audioUrl[selectedSongIndex].absoluteString ?? <#default value#>)
        print("trying to play episode at url:", songURL)
        let playerItem = AVPlayerItem(url: songURL)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    let player: AVPlayer = {
       let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    
    
    //MARK: -IB Actions and Outlets
    
    fileprivate func enlargeSongCoverImageView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.coverImage.transform = .identity
        }

    }
    
    fileprivate func shrinkSongCoverImageView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            let scale: CGFloat = 0.7
            self.coverImage.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }
    }
    
    @IBOutlet weak var playButton: UIButton! {
        didSet{
            playButton.setImage(UIImage(named: "pause 4.png"), for: .normal)
            playButton.addTarget(self, action: #selector(handlePlayandPause), for: .touchUpInside)
        }
    }
    
    
    
    @IBOutlet weak var coverImage: UIImageView! {
        didSet {
            coverImage.layer.cornerRadius = 5
            let scale: CGFloat = 0.7
            coverImage.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    
    @IBOutlet weak var currentTime: UILabel! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var durationTime: UILabel! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            likeButton.tintColor = .white
        }
    }
    
//    func checkIfUserLikedPost(_ songs: SongPost) {
//            Service.shared.checkIfUserLikedAudio(song) { didLike in
//            guard didLike == true else { return }
//
//                if let index = songs(where: { $0.id == song.id}) {
//                    self.song.didLike = true
//
////                    self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])// D
//                }
//            }
//    }

    
    @objc func handleLikeTapped() {
        
        print("Like button is being tapped")
    }
    
    @IBOutlet weak var progressBar: UISlider!
    
    
    @IBAction func handleProgressBarChange(_ sender: Any) {
        let percentage = progressBar.value
        
        guard let duration = player.currentItem?.duration else { return }
        
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        
        player.seek(to: seekTime)
    }
    
//    func checkIfUserLikedPost(_ posts: [Post]) {
//        posts.forEach { post in
//            Service.shared.checkIfUserLikedPost(post) { didLike in
//            guard didLike == true else { return }
//
//                if let index = posts.firstIndex(where: { $0.postID == post.postID}) {
//                    self.posts[index].didLike = true
//
//                    self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])// D
//                }
//            }
//        }
//    }
    
    func checkifUserLikedSong(_ song: SongPost) {
        self.songs.forEach { song in
            Service.shared.checkIfUserLikedAudio(song) { (didLike) in
                guard didLike == true else { return }
                
                if let index = self.songs.firstIndex(where: { $0.id == song.id }) {
                    self.songs[index].didLike = true
                }
                
                print("SUCCESSFULLY CHECKING IF SONG IS LIKED OR NOT")
            }
        }
    }

    
    
    @IBAction func handleLikeTapped(_ sender: Any) {
        
        Service.shared.likeSong(song: song) { (err, ref) in
            print("SUCCESSFULLY LIKED SONG")
            
            let likes = self.song.didLike ? self.song.likes - 1 : self.song.likes + 1
            self.song.didLike.toggle()
            if self.song.didLike == true {
                print("Did like")
                self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                print("unliked")
                self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)

            }
            self.checkifUserLikedSong(self.song)
            self.song.likes = likes
            
        }
    }
    


    
    
    
    @objc func handlePlayandPause() {
        print("Trying to play and pause")
        if player.timeControlStatus == .paused {
            player.play()
            playButton.setImage(UIImage(named: "pause 4.png"), for: .normal)
            self.miniPlayerPauseButton.setImage(UIImage(named: "pause 4.png"), for: .normal)
            enlargeSongCoverImageView()
        } else {
            player.pause()
            playButton.setImage(UIImage(named: "play 5.png"), for: .normal)
            self.miniPlayerPauseButton.setImage(UIImage(named: "play 5.png"), for: .normal)
            shrinkSongCoverImageView()
        }
    }



    //        NotificationCenter.default.removeObserver(self)
//    func playingAudio() {
//
//        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
//
//
//            do {
//
//                let songURL = song?.audioUrl[selectedSongIndex]
//
////                guard let fileURL = URL(string: song.audioUrl as? String ?? "") else { return }
//
//                print(songURL!)
//               // let songURL = URL(fileURLWithPath: Bundle.main.path(forResource: "siren", ofType: "wav")!)
//
//                try player = AVPlayer(url: songURL!)
//                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(currentTime1), userInfo: nil, repeats: true)
//                //            player.delegate = self
//
//                let duration : CMTime = player.currentItem!.asset.duration
//                let seconds : Float64 = CMTimeGetSeconds(duration)
//
//                durrationTime()
//                currentTime1()
//
//
//                progressBar!.maximumValue = Float(seconds)
//                progressBar!.isContinuous = true
//
//                            progressBar?.addTarget(self, action: #selector(sliderValueChanged(_:event:)), for: .valueChanged)
//
//    //            progressBar?.addTarget(self, action: #selector(sliderUsed(_:)), for: .valueChanged)
//                self.addSubview(progressBar!)
//
//                player.play()
//
//
//    //                        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
//    //                            MPMediaItemPropertyArtwork: song?.coverImage,
//    //                            MPMediaItemPropertyTitle : song?.audioName[selectedSongIndex],
//    //                            MPMediaItemPropertyArtist: song?.author.fullname,
//    //                     MPMediaItemPropertyPlaybackDuration: player.duration,
//    //
//    //                        ]
//                UIApplication.shared.beginReceivingRemoteControlEvents()
//                becomeFirstResponder()
//
//                 NotificationCenter.default.addObserver(self, selector: #selector(songEnded(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
//
//
//            } catch {
//
//            }
//
//            do {
//                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .defaultToSpeaker)
//            } catch {
//
//            }
//    }
        
//    @objc func songEnded (notification: Notification){
//            if self.song?.audioUrl.count == 1 {
//                self.player.seek(to: CMTime.zero)
//                self.player.play()
//
//            }else {
//                self.player.pause()
//
//                if self.selectedSongIndex + 1 < (self.song?.audioName.count)! {
//                    self.selectedSongIndex += 1
//                    let songURL = self.song?.audioUrl[self.selectedSongIndex]
//
//                    self.songName.text = self.song?.audioName[self.selectedSongIndex]
//                    self.player = AVPlayer(url: songURL!)
//                    self.player.play()
//                }else if self.selectedSongIndex + 1 == (self.song?.audioName.count)!{
//
//                    self.selectedSongIndex = 0
//
//                    let songURL = self.song?.audioUrl[self.selectedSongIndex]
//
//                    self.songName.text = self.song?.audioName[self.selectedSongIndex]
//                    self.player = AVPlayer(url: songURL!)
//                    self.player.play()
//
//                }
//            }
//        }
    
//        func durrationTime() {
//            let duration : CMTime = player.currentItem!.asset.duration
//            let seconds : Float64 = CMTimeGetSeconds(duration)
//
//            durationTime.text = self.stringFromTimeInterval(interval: seconds)
//        }
        
//        @objc func currentTime1() {
//            let currentDur : CMTime = player.currentTime()
//            let currentSec : Float64 = CMTimeGetSeconds(currentDur)
//
//          //  progressBar.value = Float(currentSec)
//            if isDragging {
//                progressBar.setValue(sliderTime, animated: true)
//                isDragging = false
//
//            }else{
//                progressBar.setValue(Float(currentSec), animated: true)
//
//            }
//
//            currentTime.text = self.stringFromTimeInterval(interval: currentSec)
//
//            let totalDur : CMTime = player.currentItem!.asset.duration
//            let totalSec : Float64 = CMTimeGetSeconds(totalDur)
//
//            let remainingTime = totalSec - currentSec
//
//            durationTime.text = self.stringFromTimeInterval(interval: remainingTime)
//
//        }
        
    static func initFromNib() -> PlayerDetailController {
        return Bundle.main.loadNibNamed("PlayerDetailController", owner: self, options: nil)?.first as! PlayerDetailController
        
    }
        
//    func stringFromTimeInterval(interval: TimeInterval) -> String {
//
//            let interval = Int(interval)
//            let seconds = interval % 60
//            let minutes = (interval / 60) % 60
//            return String(format: "%02d:%02d", minutes, seconds)
//        }
        

        
//    @objc func sliderValueChanged(_ playbackSlider: UISlider, event: UIEvent){
//
//               if let touchEvent = event.allTouches?.first {
//                    switch touchEvent.phase {
//                    case .began:
//                        // handle drag began
//                        //Remove observer when dragging is in progress
//                        player.pause()
//                        //progressBar.setValue(playbackSlider.value, animated: true)
//                        sliderTime = playbackSlider.value
//                        timer?.invalidate()
//                        isDragging = true
//                        break
//                    case .moved:
//                        // handle drag moved
//                        //progressBar.setValue(playbackSlider.value, animated: true)
//                        sliderTime = playbackSlider.value
//
//
//
//                        currentTime.text = self.stringFromTimeInterval(interval: TimeInterval(playbackSlider.value))
//
//
//
//
//                        let totalDur : CMTime = player.currentItem!.asset.duration
//                        let totalSec : Float64 = CMTimeGetSeconds(totalDur)
//                        let remainingTime = totalSec - Float64(playbackSlider.value)
//                        durationTime.text = self.stringFromTimeInterval(interval: remainingTime)
//
//
//
//                        break
//                    case .ended:
//                        sliderTime = playbackSlider.value
//
//                        let targetTime : CMTime = CMTimeMakeWithSeconds(Float64(sliderTime)
//                            , preferredTimescale: 1000)
//                        player.seek(to: targetTime) { isTrue in
//
//    //                        }
//                            if !self.timer!.isValid{
//                                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.currentTime1), userInfo: nil, repeats: true)
//                            }
//
//
//
//                        }
//
//                        let currentValue = Int(progressBar.value)
//                        print("Slider changing to \(currentValue) ?")
//
//
//                        currentTime.text = self.stringFromTimeInterval(interval: TimeInterval(currentValue))
//
//
//
//
//                        let totalDur : CMTime = player.currentItem!.asset.duration
//                        let totalSec : Float64 = CMTimeGetSeconds(totalDur)
//                        let remainingTime = totalSec - Float64(playbackSlider.value)
//                        durationTime.text = self.stringFromTimeInterval(interval: remainingTime)
//
//
//                        if toggleState == 1{
//
//                            player.play()
//
//                        }
//
//                        break
//                    default:
//                        break
//                    }
//                }
//            }
        

        
//        @IBAction func playPauseButtonTapped(_ sender: Any) {
//            let playBtn = sender as! UIButton
//            if toggleState == 1 {
//                player.pause()
//                toggleState = 2
//                playBtn.setImage(UIImage(named:"play 5.png"),for:UIControl.State.normal)
//
//            } else {
//                player.play()
//                toggleState = 1
//                playBtn.setImage(UIImage(named:"pause 4.png"),for:UIControl.State.normal)
//
//            }
//        }
        
        
//        @IBAction func nextButton(_ sender: Any) {
//
//            if selectedSongIndex + 1 < (song?.audioName.count)! {
//                selectedSongIndex += 1
//                player.pause()
//                let songURL = song?.audioUrl[selectedSongIndex]
//
//                print(songURL!)
//                songName.text = song?.audioName[selectedSongIndex]
//                player = AVPlayer(url: songURL!)
//                if toggleState == 1{
//
//                    player.play()
//
//                }
//
//            }
//
//        }
        
//        @IBAction func backButton(_ sender: Any) {
//
//            if selectedSongIndex != 0 {
//                selectedSongIndex -= 1
//                player.pause()
//                let songURL = song?.audioUrl[selectedSongIndex]
//
//                print(songURL!)
//                songName.text = song?.audioName[selectedSongIndex]
//                player = AVPlayer(url: songURL!)
//                if toggleState == 1{
//
//                    player.play()
//
//                }
//            }
//        }
//        deinit{
//            NotificationCenter.default.removeObserver(self)
//        }
    
//    fileprivate func setupRemoteControll() {
//        UIApplication.shared.beginReceivingRemoteControlEvents()
//
//        let commandCenter = MPRemoteCommandCenter.shared()
//
//        commandCenter.playCommand.isEnabled = true
//        commandCenter.playCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
//            self.player.play()
//            self.playButton.setImage(UIImage(named: "pause 4.png"), for: .normal)
//            self.miniPlayerPauseButton.setImage(UIImage(named: "pause 4.png"), for: .normal)
//            return .success
//        }
//        commandCenter.pauseCommand.isEnabled = true
//        commandCenter.pauseCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
//            self.player.pause()
//            self.playButton.setImage(UIImage(named: "play 5.png"), for: .normal)
//            self.miniPlayerPauseButton.setImage(UIImage(named: "play 5.png"), for: .normal)
//            return .success
//        }
//
//    }
//
//    fileprivate func setupNowPlayingInfo() {
//        var nowPlayingInfo = [String:Any]()
//
//        nowPlayingInfo[MPMediaItemPropertyTitle] = song?.audioName[selectedSongIndex]
//        nowPlayingInfo[MPMediaItemPropertyArtist] = song?.author.fullname
////        nowPlayingInfo[MPMediaItemPropertyArtwork] = song.coverImage
//
//        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
//    }
//
        @IBAction func downChevronTapped(_ sender: Any) {
//            AlbumSongArtistTableViewController.player = self.player
//            NotificationCenter.default.removeObserver(self)
//            delegate?.handleDismissal()
            
            print("dismiss")
            

            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate

            appDelegate.dismissPlayerView()

        }
    }
