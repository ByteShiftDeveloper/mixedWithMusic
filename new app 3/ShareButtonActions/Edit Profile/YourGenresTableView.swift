//
//  YourGenresTableView.swift
//  new app 3
//
//  Created by William Hinson on 10/19/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SelectyourgenresTVC"



class YourGenresTableView: UITableViewController {
    
    var selectedIndexPath: Int = -1
    
    var currentIndexSection = 0
    
    var selectedIndex : Int = -1
    var isSingleAudio = true
    static var genreLabel = ""
    static var genreLabelMultiple = ""
    var isUserFilter : Bool = false
    var selectedGenreArr : [String] = []

    var didSelectGenre : ((_ genres : [String]?)->Void)? = nil
    
    var genresArray = [ "Alternative","Blues","Children's Music","Christian & Gospel", "Classical","Comedy","Country","Dance","EDM","Electronic","French Pop","German Folk","Hip-Hop/Rap","Holiday","Indie Pop","Industrial","Instrumental","J-Pop","Jazz","K-Pop","Latin","New Age","Opera","Pop","R&B/Soul","Reggae","Rock","Songwriter","Soundtrack","Tex-Mex/Tejano","Vocal","World"]
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Edit Your Genres"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let genreDescription: UILabel = {
       let label = UILabel()
        label.text = "Select genres that best describe your sound so you can accuratly build your network of other users who share the same sound as you!"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.register(SelectyourgenresTVC.self, forCellReuseIdentifier: reuseIdentifier)
        
        var backbutton = UIButton(type: .custom)
        backbutton.setTitle("Cancel", for: .normal)
        backbutton.setTitleColor(.black, for: .normal) // You can change the TitleColor
        backbutton.tag = 1
        backbutton.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        
        var saveButton = UIButton(type: .custom)
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.black, for: .normal) // You can change the TitleColor
        saveButton.tag = 2

        saveButton.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        
        tableView.separatorStyle = .none

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        
        if !isUserFilter{
            let headerView = UIView()
            headerView.addSubview(titleLabel)
            titleLabel.centerX(inView: headerView)
            titleLabel.anchor(top: headerView.topAnchor, paddingTop: 16)
            headerView.addSubview(genreDescription)
            genreDescription.centerX(inView: headerView)
            genreDescription.anchor(top: titleLabel.bottomAnchor, left: headerView.leftAnchor, right: headerView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
            let underlineView = UIView()
            underlineView.backgroundColor = .systemGroupedBackground
            headerView.addSubview(underlineView)
            underlineView.anchor(left: headerView.leftAnchor, bottom: headerView.bottomAnchor,
                                 right: headerView.rightAnchor, height: 1)
            
            tableView.tableHeaderView = headerView
            headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 130)
        }
//        if isSingleAudio{
//            selectedIndexPath = genresArray.firstIndex(of: SelectGenreTableViewController.genreLabel) ?? -1
//            selectedIndex = genresArray.firstIndex(of: SelectGenreTableViewController.genreLabel) ?? -1
//
//        }else{
//            selectedIndex = genresArray.firstIndex(of: SelectGenreTableViewController.genreLabelMultiple) ?? -1
//
//            selectedIndexPath = genresArray.firstIndex(of: SelectGenreTableViewController.genreLabelMultiple) ?? -1
//
//        }
        tableView.reloadData()
    }
        

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return genresArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SelectyourgenresTVC
        currentIndexSection = indexPath.section
        cell.titleLabel.text = genresArray[indexPath.row]
        cell.selectGenreButton.tag = indexPath.row
        cell.selectGenreButton.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: .touchUpInside)
    
        if selectedGenreArr.contains(genresArray[indexPath.row]){
            cell.selectGenreButton.isSelected = true
        }else{
            cell.selectGenreButton.isSelected = false
        }
            
//           if selectedIndex == -1 {
//            cell.selectGenreButton.isSelected = false
//
//           }
//           else if (selectedIndex == indexPath.row) && (selectedIndexPath != selectedIndex){
//            cell.selectGenreButton.isSelected = false
//               selectedIndex = selectedIndexPath
//           }
//           else if selectedIndexPath == indexPath.row{
//            cell.selectGenreButton.isSelected = true
//
//           }else{
//            cell.selectGenreButton.isSelected = false
//
//           }
           
           return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 51
    }

       @objc func checkMarkButtonClicked ( sender: UIButton) {
        
        if !sender.isSelected && selectedGenreArr.count >= 3{
            print("Only 3 genre are allowed")
            return
        }else if !sender.isSelected {
            selectedGenreArr.append(genresArray[sender.tag])
        }else{
            selectedGenreArr.removeAll(where: {$0 == genresArray[sender.tag]})

        }
        
        sender.isSelected = !sender.isSelected

          
//           if selectedIndex == -1 {
//               selectedIndex = sender.tag
//               selectedIndexPath = sender.tag
//
//               print(selectedIndex)
//
//
//               sender.isSelected = !sender.isSelected
//           }else if selectedIndex == sender.tag{
//               selectedIndexPath = sender.tag
//
//               sender.isSelected = !sender.isSelected
//
//           }else if sender.tag != selectedIndex{
//               selectedIndexPath = sender.tag
//               sender.isSelected = !sender.isSelected
//
//
//           }
   //        if sender.isSelected {
   //
   //            sender.isSelected = false
   //        } else {
   //
   //            sender.isSelected = true
   //        }
   //
           tableView.reloadData()
       }
    
    @objc func handleBackTapped(sender : UIButton) {
        
        if sender.tag == 2{
            didSelectGenre?(selectedGenreArr)
        }else{
            didSelectGenre?(nil)
        }
//        if selectedIndexPath != -1 {
//            if isSingleAudio{
//                YourGenresTableView.genreLabel = genresArray[selectedIndexPath]
//
//            }else{
//                YourGenresTableView.genreLabelMultiple = genresArray[selectedIndexPath]
//
//
//            }
//
//        }
        self.navigationController?.popViewController(animated: true)

    }

}
