//
//  AddFeaturedArtistTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 2/26/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

class AddFeaturedArtistTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var otherUser:NSDictionary?
    var loggedInUserData:NSDictionary?
    
    var loggedInUser:User?
    
    var usersArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
           
    
    var users = [FeaturedUser]()
    
    var databaseRef = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
//               searchController.dimsBackgroundDuringPresentation = false
               definesPresentationContext = true
               tableView.tableHeaderView = searchController.searchBar
               
               databaseRef.child("users/profile").queryOrdered(byChild: "username").observe(.childAdded, with: { (snapshot) in
               
                   
                   let key = snapshot.key
                   let snapshot = snapshot.value as? NSDictionary
                   snapshot?.setValue(key, forKey: "uid")
                   
                   if(key == self.loggedInUser?.uid)
                   {
                       print("same as logged in user")
                   }
                   else
                   {
                   self.usersArray.append(snapshot)
                   }
                   //insert the rows
                   
                   
               }) { (error) in
                   print(error.localizedDescription)
               }
        
        tableView.reloadData()

    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
   override func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 1
       }

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           if searchController.isActive && searchController.searchBar.text != ""{
               return filteredUsers.count
           }
           return self.usersArray.count
       }

       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell: FindFeaturedArtistTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FindFeaturedArtistTableViewCell", for: indexPath) as! FindFeaturedArtistTableViewCell

           let user: NSDictionary
           
           if searchController.isActive && searchController.searchBar.text != ""{
            
               user = filteredUsers[indexPath.row]!
           }
           else
           {
               user = self.usersArray[indexPath.row]!
           }
           
           cell.nameLabel.text = user["username"] as? String
           cell.consideredLabel.text = user["What do you consider yourself?"] as? String
           return cell
       }
    
    func updateSearchResults(for searchController: UISearchController) {
           
           filterContent(searchText: self.searchController.searchBar.text!)
           //update the search results
       }
       
       func filterContent(searchText:String) {
           self.filteredUsers = self.usersArray.filter{ user in
               
               let username = user?["name"] as? String
           
               return(((username?.lowercased().contains(searchText.lowercased())) != nil))
           }
           tableView.reloadData()
       }
}
