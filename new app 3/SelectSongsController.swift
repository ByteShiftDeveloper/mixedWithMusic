//
//  HeaderViewTableViewController.swift
//  audioPlayerApp
//
//  Created by William Hinson on 2/4/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

protocol SelectSongDelegate: class {
    func handleMaximize()
}

class HeaderViewTableViewController: UITableViewController {
    
    weak var delegate:SelectSongDelegate?
    
    var song: SongPost? {
        didSet {
            
        }
    }
    
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackHeaderImage: UIImageView!
    
    var image: UIImageView?
    var image2: UIImageView?
    
//    var song1 = [SongPost]()
    
    var songs = [String]()
    var urls = [URL]()
        
    private let tableHeaderViewHeight: CGFloat = 300.0
    private let tableHeaderViewCutAway: CGFloat = 0.1
    
//    var headerView: HeaderView!
    var headerMaskLayer: CAShapeLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        
        trackName.text = song!.title
        
        ImageService.getImage(withURL: song!.coverImage) { image in
         self.trackImage.image = image
            self.trackHeaderImage.image = image
        }
        artistName.text = song?.author.fullname
        
   
        
        
        tableView.tableFooterView = UIView()

//        headerView = tableView.tableHeaderView as! HeaderView
//        headerView.imageView = trackImage
        tableView.tableHeaderView = nil
//        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 64)
        
        //cut away header view
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.black.cgColor
//        headerView.layer.mask = headerMaskLayer
        
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutAway/2
        tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
        
        updateHeaderView()
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
    
    func updateHeaderView() {
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutAway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: tableHeaderViewHeight)
        
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + tableHeaderViewCutAway/2
        }
        
//        headerView.frame = headerRect
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y:0))
        path.addLine(to: CGPoint(x: headerRect.width, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLine(to: CGPoint(x: 0, y: headerRect.height - tableHeaderViewCutAway))
        
        headerMaskLayer?.path = path.cgPath
    }

      override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.tableView.decelerationRate = UIScrollView.DecelerationRate.fast
      }
      
      override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
          return UITableView.automaticDimension
      }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension HeaderViewTableViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (song?.audioName.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongNameTableViewCell
        
        cell.set(song: self.song!)
        cell.songName.text = song?.audioName[indexPath.row]
        cell.songNumberLabel.text = String(indexPath.row + 1)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let song = song else { return }
        
//        let playerDetailsView = PlayerDetailController.initFromNib()
//
//        playerDetailsView.frame = self.view.frame
//        window?.addSubview(playerDetailsView)
        
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "maximize"), object: nil)
//        delegate?.handleMaximize()
        
//        TabBarController.playersDetailView.handleTapMaximize()
//        TabBarController.playersDetailView.song = song
//        TabBarController.playersDetailView.songs = [song]
        
        let y = self.view.frame.height - (self.tabBarController?.tabBar.frame.height ?? 0)  - 64
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.addPlayerView(song: song)
        appDelegate.miniPlayerInView = true
        
    }
  
}


extension HeaderViewTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
}
