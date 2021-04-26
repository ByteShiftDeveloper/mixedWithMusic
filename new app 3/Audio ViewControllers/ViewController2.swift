//
//  ViewController.swift
//  audioPlayerApp
//
//  Created by William Hinson on 1/23/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import Firebase

class ViewController2: UIViewController, UITabBarControllerDelegate {
    
    
    
    var song2 = [SongPost]()
    
    var song: SongPost?
    //    var audioName : String?
    //    var url:URL?
    
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var downChevron: UIButton!
    var timer:Timer?
    var pauseTimer : Timer = Timer()
    var player = AVPlayer()
    
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var durationTime: UILabel!
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    var trackID: Int = 0
    var toggleState = 1
    
    var selectedSongIndex = 0
    
    var ref: DatabaseReference?
    var sliderTime : Float = 0.0
    var isDragging : Bool = false
    
    
    @IBOutlet weak var playButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        
        tabBarController?.tabBar.barTintColor = UIColor.black
        tabBarController?.tabBar.isTranslucent = false
        
        tabBarController?.tabBar.tintColor = .white
        tabBarController?.tabBar.unselectedItemTintColor = .gray
        
        
        player.pause()

//        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)

        
        do {
            
            let songURL = song?.audioUrl[selectedSongIndex]
            
            print(songURL!)
           // let songURL = URL(fileURLWithPath: Bundle.main.path(forResource: "siren", ofType: "wav")!)

            try player = AVPlayer(url: songURL!)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(currentTime1), userInfo: nil, repeats: true)
            //            player.delegate = self
            
            let duration : CMTime = player.currentItem!.asset.duration
            let seconds : Float64 = CMTimeGetSeconds(duration)
            
            durrationTime()
            currentTime1()
            
            
            progressBar!.maximumValue = Float(seconds)
            progressBar!.isContinuous = true
            
                        progressBar?.addTarget(self, action: #selector(sliderValueChanged(_:event:)), for: .valueChanged)
            
//            progressBar?.addTarget(self, action: #selector(sliderUsed(_:)), for: .valueChanged)
            self.view.addSubview(progressBar!)
            
            player.play()
            
            
//                        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
//                            MPMediaItemPropertyArtwork: song?.coverImage,
//                            MPMediaItemPropertyTitle : song?.audioName[selectedSongIndex],
//                            MPMediaItemPropertyArtist: song?.author.fullname,
//                     MPMediaItemPropertyPlaybackDuration: player.duration,
//
//                        ]
            UIApplication.shared.beginReceivingRemoteControlEvents()
            becomeFirstResponder()
            
             NotificationCenter.default.addObserver(self, selector: #selector(songEnded(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
            
            
        } catch {
            
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .defaultToSpeaker)
        } catch {
            
        }
       
        
        
        //        view.setGradientBackground(colorOne: UIColor.black, colorTwo: UIColor.darkGray)
        //
        //        view.setCrazyBackground(colorOne: Colors2.black, colorTwo: Colors2.lightBlakc, colorThree: Colors2.darkGray, colorFour: Colors2.darkGray)
        //        // Do any additional setup after loading the view.
    }
    
    
    
    
    //
    //    @objc func updateSlider() {
    //        progressBar.value = Float(player.currentTime())
    //    }
    
    //    @objc func playbackSliderValueChanged (_ progressBar:UISlider) {
    //
    //        let seconds : Int64 = Int64(progressBar.value)
    //        let targetTime : CMTime = CMTimeMake(value: seconds, timescale: 1)
    //
    //        player.seek(to: targetTime)
    //
    //        if player.rate == 0 {
    //            player.play()
    //        }
    //    }
    
    
    @objc func songEnded (notification: Notification){
        if self.song?.audioUrl.count == 1 {
            self.player.seek(to: CMTime.zero)
            self.player.play()
            
        }else {
            self.player.pause()

            if self.selectedSongIndex + 1 < (self.song?.audioName.count)! {
                self.selectedSongIndex += 1
                let songURL = self.song?.audioUrl[self.selectedSongIndex]
                
                self.songName.text = self.song?.audioName[self.selectedSongIndex]
                self.player = AVPlayer(url: songURL!)
                self.player.play()
            }else if self.selectedSongIndex + 1 == (self.song?.audioName.count)!{
                
                self.selectedSongIndex = 0

                let songURL = self.song?.audioUrl[self.selectedSongIndex]
                
                self.songName.text = self.song?.audioName[self.selectedSongIndex]
                self.player = AVPlayer(url: songURL!)
                self.player.play()

            }
        }

    }
    
    
    func durrationTime() {
        let duration : CMTime = player.currentItem!.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)

        
        durationTime.text = self.stringFromTimeInterval(interval: seconds)
    }
    
    @objc func currentTime1() {
        let currentDur : CMTime = player.currentTime()
        let currentSec : Float64 = CMTimeGetSeconds(currentDur)
        
      //  progressBar.value = Float(currentSec)
        if isDragging {
            progressBar.setValue(sliderTime, animated: true)
            isDragging = false

        }else{
            progressBar.setValue(Float(currentSec), animated: true)

        }
        
        currentTime.text = self.stringFromTimeInterval(interval: currentSec)
        
        let totalDur : CMTime = player.currentItem!.asset.duration
        let totalSec : Float64 = CMTimeGetSeconds(totalDur)
        
        let remainingTime = totalSec - currentSec
        
        durationTime.text = self.stringFromTimeInterval(interval: remainingTime)
        
    }
    
    
    
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    func setUI() {
        ImageService.getImage(withURL: song!.coverImage) { image in
            self.coverImage.image = image
            self.backgroundImage.image = image
        }
        songName.text = song?.audioName[selectedSongIndex]
        artistName.text = song?.author.fullname
    }
    
    
    //    override func remoteControlReceived(with event: UIEvent?) {
    //        if let event = event {
    //            if event.type == .remoteControl {
    //                switch event.subtype {
    //                case .remoteControlPlay:
    //                    player.play()
    //                case .remoteControlPause:
    //                    player.pause()
    //                case .remoteControlNextTrack:
    //                    print("next")
    //                case .remoteControlPreviousTrack:
    //                    print("previous")
    //                default:
    //                    print("error")
    //                }
    //            }
    //        }
    //    }
    
    //    @objc func changeSliderValueFollowPlayerCurtime() {
    //
    //        let curValue = Float(player.currentTime)
    //        progressBar.value = curValue
    //
    //    }
    
        @objc func sliderValueChanged(_ playbackSlider: UISlider, event: UIEvent){
    
    //        let seconds : Float = Float(playbackSlider.value)
    //        let targetTime:CMTime = CMTimeMake(value: Int64(seconds), timescale: 1)
    //
    
            if let touchEvent = event.allTouches?.first {
                switch touchEvent.phase {
                case .began:
                    // handle drag began
                    //Remove observer when dragging is in progress
                    player.pause()
                    //progressBar.setValue(playbackSlider.value, animated: true)
                    sliderTime = playbackSlider.value
                    timer?.invalidate()
                    isDragging = true
                    break
                case .moved:
                    // handle drag moved
                    //progressBar.setValue(playbackSlider.value, animated: true)
                    sliderTime = playbackSlider.value

    
    
                    currentTime.text = self.stringFromTimeInterval(interval: TimeInterval(playbackSlider.value))
    
    
    
    
                    let totalDur : CMTime = player.currentItem!.asset.duration
                    let totalSec : Float64 = CMTimeGetSeconds(totalDur)
                    let remainingTime = totalSec - Float64(playbackSlider.value)
                    durationTime.text = self.stringFromTimeInterval(interval: remainingTime)
    
    
    
                    break
                case .ended:
                    //progressBar.setValue(playbackSlider.value, animated: true)
                    sliderTime = playbackSlider.value

//                    let currentSec : Int64 = Int64(playbackSlider.value)
//                    let targetTime : CMTime = CMTimeMake(value: currentSec, timescale: 1)
//                    player.seek(to: targetTime)
                    
                    let targetTime : CMTime = CMTimeMakeWithSeconds(Float64(sliderTime)
                        , preferredTimescale: 1000)
                    //player.seek(to: targetTime)
                    player.seek(to: targetTime) { isTrue in
//                        if !self.pauseTimer.isValid{
//                            self.pauseTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimer), userInfo: nil, repeats: true)
//                        }
                        if !self.timer!.isValid{
                            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.currentTime1), userInfo: nil, repeats: true)
                        }

                        
                        
                    }
    
                    let currentValue = Int(progressBar.value)
                    print("Slider changing to \(currentValue) ?")
    
    
                    currentTime.text = self.stringFromTimeInterval(interval: TimeInterval(currentValue))
    
    
    
    
                    let totalDur : CMTime = player.currentItem!.asset.duration
                    let totalSec : Float64 = CMTimeGetSeconds(totalDur)
                    let remainingTime = totalSec - Float64(playbackSlider.value)
                    durationTime.text = self.stringFromTimeInterval(interval: remainingTime)
    
    
    
                    if toggleState == 1{
    
                        player.play()
    
                    }
    
    
                    break
                default:
                    break
                }
            }
        }
    
 

//    @IBAction func sliderUsed(_ sender: UISlider) {
//        player.pause()
//        timer?.invalidate()
//        //progressBar.value = sender.value
//
//       //progressBar.setValue(sender.value, animated: true)
//        isDragging = true
//        sliderTime = sender.value
//        //let currentSec  = progressBar.value
////        let targetTime : CMTime = CMTimeMake(value: currentSec, timescale: 1)
//        let targetTime : CMTime = CMTimeMakeWithSeconds(Float64(sliderTime)
//            , preferredTimescale: 1000)
//        //player.seek(to: targetTime)
//        player.seek(to: targetTime) { isTrue in
//            if !self.pauseTimer.isValid{
//                self.pauseTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimer), userInfo: nil, repeats: true)
//            }
//
//
//        }
//        var currentValue = progressBar.value
//        print("Slider changing to \(currentValue) ?")
//
//
//        currentTime.text = self.stringFromTimeInterval(interval: TimeInterval(currentValue))
//
//
//
//
//        let totalDur : CMTime = player.currentItem!.asset.duration
//        let totalSec : Float64 = CMTimeGetSeconds(totalDur)
//        let remainingTime = totalSec - Float64(sliderTime)
//        durationTime.text = self.stringFromTimeInterval(interval: remainingTime)
//
//        if toggleState == 1{
//
//            player.play()
//
//        }
//
//
//    }
    
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        let playBtn = sender as! UIButton
        if toggleState == 1 {
            player.pause()
            toggleState = 2
            playBtn.setImage(UIImage(named:"play 5.png"),for:UIControl.State.normal)
            
        } else {
            player.play()
            toggleState = 1
            playBtn.setImage(UIImage(named:"pause 4.png"),for:UIControl.State.normal)
            
        }
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        
        if selectedSongIndex + 1 < (song?.audioName.count)! {
            selectedSongIndex += 1
            player.pause()
            let songURL = song?.audioUrl[selectedSongIndex]
            
            print(songURL!)
            songName.text = song?.audioName[selectedSongIndex]
            player = AVPlayer(url: songURL!)
            if toggleState == 1{
                
                player.play()
                
            }
            
        }
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        //        if trackID != 0 || trackID > 0 {
        //
        //            trackID -= 1
        //        }
        //
        //        do {
        //            let songURL = url
        //
        //            try player = AVPlayer(url: songURL!)
        //        } catch {
        //
        //
        //        }
        
        if selectedSongIndex != 0 {
            selectedSongIndex -= 1
            player.pause()
            let songURL = song?.audioUrl[selectedSongIndex]
            
            print(songURL!)
            songName.text = song?.audioName[selectedSongIndex]
            player = AVPlayer(url: songURL!)
            if toggleState == 1{
                
                player.play()
                
            }
            
        }
        
        
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)

    }
    
    @IBAction func downChevronTapped(_ sender: Any) {
//        AlbumSongArtistTableViewController.player = self.player
        NotificationCenter.default.removeObserver(self)

        dismiss(animated: true, completion: nil)
    }
    
}

//extension ViewController2: AVAudioPlayerDelegate {
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        if flag {
//            do {
//                
//                let songURL = url
//              
//                try self.player = AVPlayer(url: songURL!)
//                
//            
////                    progressBar.maximumValue = Float(player.duration)
////                    timer = Timer.scheduledTimer(timeInterval: 0.00001, target: self, selector: #selector(changeSliderValueFollowPlayerCurtime), userInfo: nil, repeats: true)
////                    player.delegate = self
//                    
//                    player.play()
//                } catch {
//                    
//                }
//        }
//    }
//

//}

