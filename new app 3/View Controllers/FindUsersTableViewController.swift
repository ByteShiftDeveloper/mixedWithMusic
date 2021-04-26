//
//  FindUsersTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 12/19/19.
//  Copyright © 2019 Mixed WIth Music. All rights reserved.
//

import UIKit
import SwiftUI
import FirebaseDatabase
import Firebase

class FindUsersTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet var followUsersTableView: UITableView!
    
    
    
    
    var otherUser:NSDictionary?
    var loggedInUserData:NSDictionary?
    
    var loggedInUser:User?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var usersArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    
    var users = [Users]()
    
    var user1: Users?

    
    
    var databaseRef = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tabBar = self.tabBarController?.tabBar else { return }
        
        tabBar.tintColor = UIColor.black
        tabBar.barTintColor = UIColor.white
        
    
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
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
                self.followUsersTableView.insertRows(at: [IndexPath(row:self.usersArray.count-1,section: 0)], with: UITableView.RowAnimation.automatic)
            }
            //insert the rows
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
//
//    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
//        return "FindUserTableViewCell"
//    }

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
        let cell: FindUserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FindUserTableViewCell", for: indexPath) as! FindUserTableViewCell

        let user: NSDictionary
        
        if searchController.isActive && searchController.searchBar.text != ""{
         
            user = filteredUsers[indexPath.row]!
        }
        else
        {
            user = self.usersArray[indexPath.row]!
        }
        
        
        cell.usernameLabel.text = user["username"] as? String
        cell.artistDJLabel.text = user["What do you consider yourself?"] as? String

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "UsersProfileViewController") as? UsersProfileViewController
        
        self.present(vc!, animated: true, completion: nil)

        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let showUserProfileViewController = segue.destination as! UsersProfileViewController
//        
//        showUserProfileViewController.loggedInUser = self.loggedInUser
//        
//        if let indexPath = tableView.indexPathForSelectedRow {
//            let user = usersArray[indexPath.row]
//            showUserProfileViewController.otherUser = user
//        }
//        
//    }
    
}
