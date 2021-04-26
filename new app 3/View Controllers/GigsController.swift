//
//  GigsController.swift
//  new app 3
//
//  Created by William Hinson on 2/26/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "reuseIdent"

class GigsController: UITableViewController, UISearchBarDelegate {
    
    var searchBar = UISearchBar()
    
    private var gigs = [Gigs]() {
        didSet { tableView.reloadData() }
    }
    
    var inSearchMode = false
    
    var filteredGigs = [Gigs]()
    
    var selectedGenres : [String] = []
    var selectedabdmp : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGigs()
        configureSearchBar()
        tableView.register(GigPostingCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = UIColor(named: "DefaultBackgroundColor")
        tableView.separatorStyle = .none
    }
    
    func fetchGigs() {
        Service.shared.fetchGigs { gigs in
            self.gigs = gigs.sorted(by: { $0.createdAt > $1.createdAt})
        }
    }
    
    func configureSearchBar() {
        let image = UIImage()
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.backgroundImage = image
        searchBar.backgroundColor = .clear
        searchBar.tintColor = UIColor(named: "BlackColor")
        searchBar.isTranslucent = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "slider.horizontal.3"), for: .bookmark, state: .normal)
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.lowercased()
        
        if searchText.isEmpty || searchText == " " {
            inSearchMode = false
            tableView.reloadData()
        } else {
            inSearchMode = true
            filteredGigs = gigs.filter({ (gig) -> Bool in
                return gig.title.contains(searchText)
            })
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        searchBar.showsCancelButton = false
        
        searchBar.text = nil
        
        inSearchMode = false
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let controller = SearchFilterCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        //        controller.filterClosed = {  (userFilters,genresArr)  in
        //
        //        }
        controller.selectedGenres = selectedGenres
        controller.selectedabdmp = selectedabdmp
        
        
        
        
        controller.filterClosed = {  (userFilters,genresArr, location) in
            print("user filter count:\(userFilters?.count ?? 0)")
            
            self.selectedGenres = genresArr ?? []
            self.selectedabdmp = userFilters ?? []
            
            var userIDs : [String] = []
            var genreIDs : [String] = []
            var userFilterId : [String] = []
            
            
            if userFilters?.count ?? 0 > 0 {
                //                 userIDs = self.users.filter({userFilters!.contains($0.artistBand)}).map({$0.uid})
                userFilterId = self.gigs.filter({userFilters!.contains($0.lookingFor)}).map({$0.user.uid})
                
            }
            if let genres = genresArr{
                for i in genres{
                    //                    let tempIDs = self.users.filter({$0.genre.localizedCaseInsensitiveContains(i)}).map({$0.uid})
                    //                    userIDs.append(contentsOf: tempIDs)
                    
                    let tempIDs = self.gigs.filter({$0.genre.localizedCaseInsensitiveContains(i)}).map({$0.user.uid})
                    genreIDs.append(contentsOf: tempIDs)
                }
            }
            
            if (userFilters?.count ?? 0  > 0) && (genresArr?.count ?? 0 > 0) {
                let userSet = Set(userFilterId)
                let genreSet = Set(genreIDs)
                userIDs = Array(userSet.intersection(genreSet))
            }else if userFilters?.count ?? 0 > 0{
                userIDs = Array(Set(userFilterId))
            }else{
                userIDs = Array(Set(genreIDs))
            }
            
            
            //            userIDs = Array(Set(userIDs))
            
            self.filteredGigs = self.gigs.filter({userIDs.contains($0.user.uid)})
            self.inSearchMode = true
            
            if userFilters?.count == 0 && genresArr?.count == 0 {
                self.inSearchMode = false
            }
            self.tableView.reloadData()
            
        }
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        //        navigationController?.pushViewController(controller, animated: true)
    }
}


extension GigsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredGigs.count
        } else {
            return gigs.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GigPostingCell
        
        var gig: Gigs!
        
        if inSearchMode {
            gig = filteredGigs[indexPath.row]
        } else {
            gig = gigs[indexPath.row]
        }
        cell.gig = gig
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let user = gigs[indexPath.row].user
        let gig = gigs[indexPath.row]
        let controller = ApplyToGigController()
        controller.user = user
        controller.gigs = gig
        navigationController?.pushViewController(controller, animated: true)
    }
}
