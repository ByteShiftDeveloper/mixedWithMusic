//
//  EditUserLocationTV.swift
//  new app 3
//
//  Created by William Hinson on 3/3/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import MapKit

private let reuseIdent = "LocationTVC"

class EditUserLocationTV: UITableViewController, MKLocalSearchCompleterDelegate, UISearchBarDelegate {
    
    var searchCompleter = MKLocalSearchCompleter()
    
    var searchResults = [MKLocalSearchCompletion]()
    
    var searchBar = UISearchBar()
    
    static var location = ""
    
    var selectedLocation : String = ""
    var didSelectLocation : ((_ location : String?)->Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        searchBar.delegate = self
        configureTVC()
        configureSearchBar()
    }
    
    func configureTVC() {
        tableView.register(LocationTVC.self, forCellReuseIdentifier: reuseIdent)
    }
    
    func configureSearchBar() {
        let image = UIImage()
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
//      searchBar.barTintColor = .white
        searchBar.backgroundImage = image
        searchBar.backgroundColor = .clear
        searchBar.tintColor = .black
        searchBar.isTranslucent = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancle))
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func handleCancle() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension EditUserLocationTV {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResult = searchResults[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdent, for: indexPath) as! LocationTVC
        
        cell.locationLabel.text = searchResult.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)

        let result = searchResults[indexPath.row].title
        
        let controller = UserLocationCell()
        
        selectedLocation = result
        
//       let searchRequest = MKLocalSearch.Request(completion: result)
        
        EditUserLocationTV.location = searchResults[indexPath.row].title
        didSelectLocation?(result)
        
        dismiss(animated: true) {
            print(result)
            EditUserLocationTV.location = self.searchResults[indexPath.row].title
            controller.locationName.text = self.searchResults[indexPath.row].title
            self.didSelectLocation?(result)
        }
        
//       let search = MKLocalSearch(request: searchRequest)
//            search.start { (response, error) in
//                guard let coordinate = response?.mapItems[0].placemark.coordinate else {
//                    return
//                }
//
//                guard let name = response?.mapItems[0].name else {
//                 return
//           }
//
//           let lat = coordinate.latitude
//           let lon = coordinate.longitude
//
//           print(lat)
//           print(lon)
//           print(name)
//
//        }
    }
}

extension EditUserLocationTV {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Setting our searchResults variable to the results that the searchCompleter returned
        searchResults = completer.results

        // Reload the tableview with our new searchResults
        tableView.reloadData()
    }

    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
    }
}
