//
//  VideoLauncher.swift
//  new app 3
//
//  Created by William Hinson on 10/7/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlayerView: UIView {
    
    var videoString: String?
    
    var observer: NSKeyValueObservation?
    
    var videoLauncher : VideoLauncher!
    var videoUrl : URL?
    var playerLayer : AVPlayerLayer!
    let keyWindow = UIApplication.shared.connectedScenes
       .map({$0 as? UIWindowScene})
       .compactMap({$0})
       .first?.windows.first
    

    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        aiv.tintColor = .white
        return aiv
    }()
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    let controllsView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
//        button.tintColor = UIColor(white: 0, alpha: 0.5)
//        button.setTitle("x", for: .normal)
//        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(white: 0, alpha: 0.5)
        button.layer.cornerRadius = 30/2
//        button.contentVerticalAlignment = .fill
//        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.isHidden = true
        return button
    }()
    
    let pausePlayButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.tintColor = .white
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.isHidden = true
        return button
    }()
    
    let smallPlayPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.tintColor = .white
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = false
        return button
    }()
    
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    let dividerLabel: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()

    
    let videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .lightGray
        return slider
    }()
    
    let currentTime: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    var isPlaying = false
    
    @objc func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            smallPlayPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            smallPlayPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
     
        isPlaying = !isPlaying
    }
    
    @objc func handleDismiss() {
        print("Dismissing the video")
//        let controller = VideoLauncher()
        
        
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.player?.pause()
            let frame = CGRect(x: 0, y: self.videoLauncher.view.frame.maxY , width: self.videoLauncher.view.frame.width, height: 0)
            self.videoLauncher.view.frame = frame
            self.videoLauncher.videoPlayerView.frame = frame
            self.playerLayer.frame = frame

        } completion: { (completedAnuimation) in
            self.videoLauncher.view.removeFromSuperview()
        }
        
//        controller.dismissvideoPlayer()
//        self.dismissvideoPlayer()

//        UIView.animate(withDuration: 0.3) {
//            self.frame.origin.y += (self.keyWindow?.frame.height)!
//            let videoPlayerView = VideoLauncher()
//            videoPlayerView.dismissvideoPlayer()
////            let view = UIView(frame: self.keyWindow!.frame)
////            view.backgroundColor = .clear
//            self.player?.pause()
//        }
    }
    
    var controllsShown: Bool = false
    
    func showControlls() {
        UIView.animate(withDuration: 0.3) {
            self.pausePlayButton.alpha = 1
            self.dismissButton.alpha = 1
            self.controllsView.alpha = 1
            

        }

    }
    
    func hideControlls() {
        UIView.animate(withDuration: 0.3) {
            self.pausePlayButton.alpha = 0
            self.dismissButton.alpha = 0
            self.controllsView.alpha = 0

        }
    }
    
    @objc func toggleControlls() {
        print("ATTEMPTING TO HIDE CONTROLLS")
        
        if controllsShown {
            showControlls()
        } else {
            hideControlls()
        }
        
        controllsShown = !controllsShown
    }
    
    @objc func handleVideoSliderChange() {
        let percentage = videoSlider.value
        
        guard let duration = player?.currentItem?.duration else { return }
        
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
                
        player?.seek(to: seekTime)

    }
    
    func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds((player?.currentTime())!)
        let durationSeconds = CMTimeGetSeconds(player?.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        self.videoSlider.value = Float(percentage)
    }
        
    override init(frame:CGRect) {
        super.init(frame: frame)
//        setupPlayer()
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleControlls))
        gesture.numberOfTapsRequired = 1
        controlsContainerView.isUserInteractionEnabled = true
        controlsContainerView.addGestureRecognizer(gesture)
        
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        addSubview(controllsView)
        controllsView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,paddingBottom: 82, height: 50)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = controllsView.bounds
        controllsView.addSubview(blurredEffectView)
        
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//
//
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.anchor(width: 50, height: 50)
        pausePlayButton.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
//
        controllsView.addSubview(videoLengthLabel)
        videoLengthLabel.anchor(right: controllsView.rightAnchor, paddingRight: 8, height: 24)
        videoLengthLabel.centerY(inView: controllsView)
        
        controllsView.addSubview(dividerLabel)
        dividerLabel.anchor(right: videoLengthLabel.leftAnchor, paddingRight: 4, height: 24)
        dividerLabel.centerY(inView: controllsView)
        
        controllsView.addSubview(currentTime)
        currentTime.anchor(right: dividerLabel.leftAnchor, paddingRight: -6, width: 50 ,height: 24)
        currentTime.centerY(inView: controllsView)

        controlsContainerView.addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 100, paddingLeft: 16, width: 30, height: 30)
        dismissButton.titleLabel?.textAlignment = .center
        dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
//
        controllsView.addSubview(smallPlayPauseButton)
        smallPlayPauseButton.anchor(left: controllsView.leftAnchor, paddingLeft: 8, width: 15,  height: 15)
        smallPlayPauseButton.centerY(inView: controllsView)
        smallPlayPauseButton.addTarget(self, action: #selector(handlePause), for: .touchUpInside)



        controllsView.addSubview(videoSlider)
        videoSlider.anchor(left: smallPlayPauseButton.rightAnchor, right: currentTime.leftAnchor, paddingLeft: 16, paddingRight: 16, height: 20)
        videoSlider.centerY(inView: controllsView)
        videoSlider.addTarget(self, action: #selector(handleVideoSliderChange), for: .touchUpInside)
        
    }
    var player: AVPlayer?
    
    func setupPlayer() {
        
//        let urlString = "https://firebasestorage.googleapis.com/v0/b/mixed-with-music-28704.appspot.com/o/postUploads%2FBB624E41-2FEE-43AA-88CF-62BB64CE3438.mp4?alt=media&token=10a59d68-2902-4f87-8c28-feee93c426cc"
        if let url = videoUrl{
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
//        self.layer.addSublayer(playerLayer)
            self.layer.insertSublayer(playerLayer, at: 0)
        playerLayer.frame = self.frame
    
        player?.play()
        self.observer = player?.currentItem?.observe(
            \.loadedTimeRanges,
            options: .new
        ) { (item: AVPlayerItem, value: NSKeyValueObservedChange<[NSValue]>) in
            self.activityIndicatorView.stopAnimating()
            self.controlsContainerView.backgroundColor = .clear
            self.pausePlayButton.isHidden = false
            self.isPlaying = true
            
            if let duration = self.player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                self.videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }

            
            
            }
            
            let interval = CMTimeMake(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self ](time) in
                self?.currentTime.text = time.toDisplayString()
                let durationTime = self?.player?.currentItem?.duration
//                self?.durationTime.text = durationTime?.toDisplayString()
//
                self?.updateCurrentTimeSlider()
    
            }
            
        }else{
            
        }

    }
    
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        //this is when the player is ready and rendering frames
//        if keyPath == "currentItem.lzoadedTimeRanges" {
//            activityIndicatorView.stopAnimating()
//            controlsContainerView.backgroundColor = .clear
//            pausePlayButton.isHidden = false
//            isPlaying = true
////
////            if let duration = player?.currentItem?.duration {
////                let seconds = CMTimeGetSeconds(duration)
////
////                let secondsText = Int(seconds) % 60
////                let minutesText = String(format: "%02d", Int(seconds) / 60)
////                videoLengthLabel.text = "\(minutesText):\(secondsText)"
////            }
//        }
//    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {

    
    var startingFrame: CGRect?
    var startingImageView: UIImageView?
    var videoPlayerView : VideoPlayerView!
    var view : UIView!
    var videoUrl : URL?
    
    let keyWindow = UIApplication.shared.connectedScenes
       .map({$0 as? UIWindowScene})
       .compactMap({$0})
       .first?.windows.first
    
    
    func showVideoPlayer() {
        
        print("SHowing video player......")
         view = UIView(frame: keyWindow!.frame)
       
        
        view.frame = CGRect(x: 0, y: keyWindow!.frame.height, width: keyWindow!.frame.width, height: 10)
        
        view.backgroundColor = .black
        
        let height = keyWindow!.frame.height
        let videoPlayerFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
         videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
        videoPlayerView.videoLauncher = self
        videoPlayerView.videoUrl = videoUrl
        videoPlayerView.setupPlayer()
        view.addSubview(videoPlayerView)
//        videoPlayerView.dismissButton.addTarget(keyWindow, action: #selector(dismissvideoPlayer), for: .touchUpInside)
        keyWindow?.addSubview(view)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.view.frame = self.keyWindow!.frame
        } completion: { (completedAnuimation) in
            //do something here later
        }

    }
    
//    @objc func dismissvideoPlayer() {
//
//    }
}
