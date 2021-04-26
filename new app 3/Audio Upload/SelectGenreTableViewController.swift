//
//  SelectGenreTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 7/23/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GenreHeaderCell"
private let reuseIdentifier2 = "SelectGenreCell"


class SelectGenreTableViewController: UITableViewController {
    
    var selectedIndexPath: Int = -1
    
    var currentIndexSection = 0
    
    var selectedIndex : Int = -1
    var isSingleAudio = true
    static var genreLabel = ""
    static var genreLabelMultiple = ""

    
    var genresArray = [ "Alternative","Blues","Children's Music","Christian & Gospel", "Classical","Comedy","Country","Dance","EDM","Electronic","French Pop","German Folk","Hip-Hop/Rap","Holiday","Indie Pop","Industrial","Instrumental","J-Pop","Jazz","K-Pop","Latin","New Age","Opera","Pop","R&B/Soul","Reggae","Rock","Songwriter","Soundtrack","Tex-Mex/Tejano","Vocal","World"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.register(GenreHeaderCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(SelectGenreCell.self, forCellReuseIdentifier: reuseIdentifier2)
        
        var backbutton = UIButton(type: .custom)
        backbutton.setTitle("Back", for: .normal)
        backbutton.setTitleColor(.black, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
        if isSingleAudio{
            selectedIndexPath = genresArray.firstIndex(of: SelectGenreTableViewController.genreLabel) ?? -1
            selectedIndex = genresArray.firstIndex(of: SelectGenreTableViewController.genreLabel) ?? -1

        }else{
            selectedIndex = genresArray.firstIndex(of: SelectGenreTableViewController.genreLabelMultiple) ?? -1

            selectedIndexPath = genresArray.firstIndex(of: SelectGenreTableViewController.genreLabelMultiple) ?? -1

        }
        tableView.reloadData()
    }
        

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
        return genresArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GenreHeaderCell
        
        return cell
        } else {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier2, for: indexPath) as! SelectGenreCell
       currentIndexSection = indexPath.section
        cell.titleLabel.text = genresArray[indexPath.row]
            cell.selectGenreButton.tag = indexPath.row
            cell.selectGenreButton.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: .touchUpInside)
          
           if selectedIndex == -1 {
            cell.selectGenreButton.isSelected = false

           }
           else if (selectedIndex == indexPath.row) && (selectedIndexPath != selectedIndex){
            cell.selectGenreButton.isSelected = false
               selectedIndex = selectedIndexPath
           }
           else if selectedIndexPath == indexPath.row{
            cell.selectGenreButton.isSelected = true
            
           }else{
            cell.selectGenreButton.isSelected = false

           }
           
           return cell
           }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
        return 39
        } else {
            return 51
        }
    }

       @objc func checkMarkButtonClicked ( sender: UIButton) {
           
          
           if selectedIndex == -1 {
               selectedIndex = sender.tag
               selectedIndexPath = sender.tag

               print(selectedIndex)
               
               sender.isSelected = !sender.isSelected
           }else if selectedIndex == sender.tag{
               selectedIndexPath = sender.tag

               sender.isSelected = !sender.isSelected

           }else if sender.tag != selectedIndex{
               selectedIndexPath = sender.tag
               sender.isSelected = !sender.isSelected


           }
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
    
    @objc func handleBackTapped() {
        if selectedIndexPath != -1 {
            if isSingleAudio{
                SelectGenreTableViewController.genreLabel = genresArray[selectedIndexPath]
                
            }else{
                SelectGenreTableViewController.genreLabelMultiple = genresArray[selectedIndexPath]

            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}
