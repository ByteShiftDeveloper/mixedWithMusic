//
//  GenreHeaderViewTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 3/24/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class GenreHeaderViewTableViewController: UITableViewController {
    
    @IBOutlet weak var genreImage1: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
       
    var genreName = String()
    var genreImage = UIImage()
    
    
    private let tableHeaderViewHeight: CGFloat = 150.0
    private let tableHeaderViewCutAway: CGFloat = 0.1
    
    var headerView: HeaderView!
    var headerMaskLayer: CAShapeLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        setUI()
        
        
        tableView.tableFooterView = UIView()

        headerView = tableView.tableHeaderView as! HeaderView
//        headerView.imageView = trackImage
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 64)
        
        //cut away header view
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = headerMaskLayer
        
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutAway/2
        tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
        
        updateHeaderView()
    }
    func setUI() {
        genreLabel.text = genreName
        genreImage1.image = genreImage
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
           
           headerView.frame = headerRect
           
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



    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "GenreHeaderViewTableViewCell", for: indexPath) as! GenreHeaderViewTableViewCell
          
          return cell
      }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}

extension GenreHeaderViewTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
}

