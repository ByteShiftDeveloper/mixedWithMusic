//
//  SearchTableViewController.swift
//  new app 3
//
//  Created by William Hinson on 4/4/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit
import Firebase

class SearchTableViewController: UITableViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var users = [User]()
    var filteredUsers = [User]()
    var inSearchMode = false
    var collectionView: UICollectionView!
    var collectionViewEnabled = true

    let cellId : String = "cellId"
    let cellId2 : String = "cellId2"
    let cellId3 : String = "cellId3"
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FindUserTableViewCell.self, forCellReuseIdentifier: "userCell")
        

        fetchUser()
                
        configureSearchBar()
        
        configureCollectionView()

    }
    
     override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
//            searchBar.becomeFirstResponder()
        tableView.backgroundColor = .black
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let tabBar = self.tabBarController?.tabBar else { return }
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor.black
        tabBar.isTranslucent = false
      navigationController?.navigationBar.backgroundColor = Colors.blackColor


    }
    
       
    override func viewWillDisappear(_ animated: Bool) {
        guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.tintColor = UIColor.black
        tabBar.barTintColor = UIColor.white
        tabBar.isTranslucent = false
       }
    
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
         dismiss(animated: false, completion: nil)
     }
    
    func fetchAllUser() {
        UserService.shared.fetchAllUsers { users in
            users.forEach { user in
                print("User is \(user.fullname)")
            }
            
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if inSearchMode {
            return filteredUsers.count
        } else {
            return users.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! FindUserTableViewCell
        
        
        var user: User!
        
        if inSearchMode {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        cell.user = user
        
        return cell
    }
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
//            let user = users[indexPath.row]
                    
//            let vc = storyboard?.instantiateViewController(identifier: "UsersProfileTableViewController") as! UsersProfileTableViewController
            
//            let vc = ProfileCollectionViewController()
//
//            vc.userToLoadFromSearchVC = user
//
//            navigationController?.pushViewController(vc, animated: true)
            
            let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
            
//            var user: User!
//
//            if inSearchMode {
//                user = filteredUsers[indexPath.row]
//            } else {
//                user = users[indexPath.row]
//            }
            
            // create instance of user profile vc
            let userProfileVC = ProfileCollectionViewController(user: user)
            
            // passes user from searchVC to userProfileVC
//            userProfileVC.user = user
//
            // push view controller
            navigationController?.pushViewController(userProfileVC, animated: true)
           
        }
    
    //MARK: -UICollectionView
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let frame = CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.height - (tabBarController?.tabBar.frame.height)! - (navigationController?.navigationBar.frame.height)!)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .black
        
        tableView.addSubview(collectionView)
        collectionView.register(ExploreCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ExploreCell2.self, forCellWithReuseIdentifier: cellId2)
        collectionView.register(ExploreCell3.self, forCellWithReuseIdentifier: cellId3)
        tableView.separatorColor = .clear
        
        view.backgroundColor = .black
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 1
     }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! ExploreCell2
                collectionView.tag = 0
            return cell
            } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId3, for: indexPath) as! ExploreCell3
                collectionView.tag = 1
                   return cell
            } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExploreCell
                collectionView.tag = 2
            return cell
            }
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = CGFloat(240)
        
        return CGSize(width: width, height: height)
    }

     
   func configureSearchBar() {
          searchBar.sizeToFit()
          searchBar.delegate = self
          navigationItem.titleView = searchBar
        searchBar.barTintColor = .black
          searchBar.tintColor = .black
      }
      
      func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
          searchBar.showsCancelButton = true
          
//          fetchUsers()
          
          collectionView.isHidden = true
          collectionViewEnabled = false
          
          tableView.separatorColor = .lightGray
      }
      
      func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          
          let searchText = searchText.lowercased()
          
          if searchText.isEmpty || searchText == " " {
              inSearchMode = false
              tableView.reloadData()
          } else {
              inSearchMode = true
              filteredUsers = users.filter({ (user) -> Bool in
                  return user.username.contains(searchText)
              })
              tableView.reloadData()
          }
      }
      
      func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          searchBar.endEditing(true)
          searchBar.showsCancelButton = false
          searchBar.text = nil
          inSearchMode = false
          
          collectionViewEnabled = true
          collectionView.isHidden = false
          
          tableView.separatorColor = .clear
          tableView.reloadData()
      }
    
    func fetchUser(){
    
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            print(snapshot)
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let uid = snapshot.key
            
            let user = User(uid: uid, dictionary: dictionary)
            
            self.users.append(user)
            
            self.tableView.reloadData()
            
        }
    
    }

}
