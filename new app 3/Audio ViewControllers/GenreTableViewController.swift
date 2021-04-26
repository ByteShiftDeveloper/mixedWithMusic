//
//  GenreTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 2/25/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let reuseIdentifier2 = "Cell"


class GenreTableViewController: UITableViewController {
    
    var selectedIndexPath: Int = -1
    
    var currentIndexSection = 0
    
    var selectedIndex : Int = -1
    static var genreLabel = ""
    
    var genresArray = [ "Alternative","Blues","Children's Music","Christian & Gospel", "Classical","Comedy","Country","Dance","EDM","Electronic","French Pop","German Folk","Hip-Hop/Rap","Holiday","Indie Pop","Industrial","Instrumental","J-Pop","Jazz","K-Pop","Latin","New Age","Opera","Pop","R&B/Soul","Reggae","Rock","Songwriter","Soundtrack","Tex-Mex/Tejano","Vocal","World"]



    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.register(MusicGenresTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.register(GenreHeadingTableViewCell.self, forCellReuseIdentifier: reuseIdentifier2)


    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UploadTrackTableViewController" {
//            let destVC = segue.destination as! UploadTrackTableViewController
//            destVC.genre = sender as? String
//        }
//    } 
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
                return 1
            } else  {
            return genresArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier2, for: indexPath) as! GenreHeadingTableViewCell
        currentIndexSection = indexPath.section
        
        return cell
    } else {
        
    
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MusicGenresTableViewCell
        currentIndexSection = indexPath.section
        cell.genreLabel?.text = genresArray[indexPath.row]
        cell.uncheckedButton?.tag = indexPath.row
        cell.uncheckedButton?.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: .touchUpInside)
       
        if selectedIndex == -1 {
            cell.uncheckedButton?.isSelected = false

        }
        else if (selectedIndex == indexPath.row) && (selectedIndexPath != selectedIndex){
            cell.uncheckedButton?.isSelected = false
            selectedIndex = selectedIndexPath
        }
        else if selectedIndexPath == indexPath.row{
            cell.uncheckedButton?.isSelected = true

        }else{
            cell.uncheckedButton?.isSelected = false

        }
        
        return cell
        }
    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let Storyboard = UIStoryboard(name: "UploadTrackTableViewController", bundle: nil)
//        let DvC = Storyboard.instantiateViewController(withIdentifier: "UploadTrackTableViewController") as! UploadTrackTableViewController
//        
////        DvC.selectGenre = genresArray[indexPath.row] as! String
//        self.navigationController?.pushViewController(DvC, animated: true)
//    }
//    
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
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if selectedIndexPath != -1 {
            GenreTableViewController.genreLabel = genresArray[selectedIndexPath]
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
