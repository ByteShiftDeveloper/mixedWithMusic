//
//  SearchFilterCollectionViewController.swift
//  new app 3
//
//  Created by William Hinson on 10/29/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let reuseIdentifier2 = "LocationFilter"
private let reuseIdentifier3 = "FilterGenreCVC"
private let reuseIdentifier4 = "FilterFooterCell"
private let footerID = "FilterFooter"

enum PickType {
    case City
    case State
}

class SearchFilterCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var locationCell = LocationFilter()
    var isReset : Bool = false
    var filterClosed : ((_ userFilter : [String]?, _ genreArr : [String]?, _ location : [String]?)->Void)? = nil
    var selectedGenres : [String] = []
    var selectedabdmp : [String] = []
    var selectedLocation : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if FilterLocationTV.location != "" {
            locationCell.locationName.text = FilterLocationTV.location
            locationCell.locationName.textColor = .black
        } else {
            locationCell.locationName.text = "Any"
            locationCell.locationName.textColor = .lightGray
        }

    }
    
    fileprivate func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let frame = CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.height)
//                            -
//                            (tabBarController?.tabBar.frame.height)! - (navigationController?.navigationBar.frame.height)!)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
//        collectionView.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        self.collectionView!.register(SearchFilterUserCVC.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(LocationFilter.self, forCellWithReuseIdentifier: reuseIdentifier2)
        self.collectionView!.register(FilterGenreCVC.self, forCellWithReuseIdentifier: reuseIdentifier3)
        self.collectionView.register(FilterFooterCell.self, forCellWithReuseIdentifier: reuseIdentifier4)
        self.collectionView.register(FilterFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerID)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancle))
        navigationItem.title = "Filter"
        
        let customButton = UIButton(type: .custom)
        customButton.setTitle("Reset", for: .normal)
        customButton.setTitleColor(.black, for: .normal)
        customButton.addTarget(self, action: #selector(resetFilters), for: .touchUpInside)
        
    
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .redo, target: self, action: #selector(resetFilters))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customButton)
        
        navigationController?.navigationBar.tintColor = .black

//        tableView.addSubview(collectionView)
        self.view.addSubview(collectionView)
   

        
        collectionView.backgroundColor = .white

//         if let layout = collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    @objc func handleCancle() {
        filterClosed?([],[], [])
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
       print("Successfully clicked donne")
        let cell = collectionView.cellForItem(at: [0,0]) as? SearchFilterUserCVC
        print("selected filters count :\(cell?.selectedabdmp.count ?? 0 )")
        filterClosed?(cell?.selectedabdmp, selectedGenres, selectedLocation)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func resetFilters(){
        let alert = UIAlertController(title: "Reset Filters", message: "Are you sure you want to reset yor filters?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            print("Done Handled")
            self.isReset = true
            self.collectionView.reloadData()
            print("reset filters")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Done Handled")
        }
        alert.addAction(yes)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
      
    }


    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchFilterUserCVC
//            cell.collectionView.tag = 100
//            cell.collectionView.delegate = self
            if isReset{
                cell.selectedabdmp = []
                cell.collectionView.reloadData()
                
            }else{
                
                cell.selectedabdmp = selectedabdmp
                cell.collectionView.reloadData()
                
            }
            
            cell.del = self
            
        return cell
        } else if indexPath.section == 1 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier3, for: indexPath) as! FilterGenreCVC
            if isReset{
                selectedGenres.removeAll()
                cell.locationName.text = "Any"
            }else{
                if selectedGenres.count > 0 {
                    cell.locationName.text = selectedGenres.joined(separator: ",")
                }else{
                    cell.locationName.text = "Any"
                }
                
            }
            
        return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as! LocationFilter
        if isReset {
            selectedLocation.removeAll()
            cell.locationName.text = "Any"
        } else {
            if FilterLocationTV.location != "" {
                cell.locationName.text = selectedLocation.joined()
                cell.locationName.textColor = .black
            } else {
                cell.locationName.text = "Any"
                cell.locationName.textColor = .lightGray
            }
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
        return CGSize(width: view.frame.width, height: 240)
        }
        return CGSize(width: view.frame.width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 2 {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerID, for: indexPath) as! FilterFooter
            footer.applyButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        return footer
        }

        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 2 {
        return CGSize(width: view.frame.width, height: 100)
    }
        
        return CGSize(width: 0, height: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let cell = collectionView.cellForItem(at: [0,0]) as? SearchFilterUserCVC
            selectedabdmp = cell!.selectedabdmp
            let controller = YourGenresTableView() //FilterGenreTV()
            controller.isUserFilter = true
            controller.selectedGenreArr = selectedGenres
            controller.didSelectGenre = { genres in
                print("genre count :\(genres?.count)")
                if let genre = genres{
                    self.selectedGenres = genre
                    self.isReset = false
                    self.collectionView.reloadData()
                }
            }
            navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.section == 0 {
            print("Toggling selected button")
        } else if indexPath.section == 2 {
            let controller = FilterLocationTV()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            controller.selectedLocationArr = selectedLocation
            controller.didSelectLocation = { location in
                if let location = location {
                    self.selectedLocation = location
                    self.isReset = false
                    self.collectionView.reloadData()
                }
            }
            present(nav, animated: true, completion: nil)
        }
        isReset = false
    }

}

extension SearchFilterCollectionViewController: UserFilterDelegate {
    func handleSelect(_ cell: SubFilterUserCVC) {
        print("Selecting this button \(cell.genre)")
    }
}

extension SearchFilterCollectionViewController: LocationFilterDelegate {
    func locationSelect(_ cell: LocationFilter) {
        
    }
}

extension SearchFilterCollectionViewController: FilterFooterCellDelegate {
    func handleDismiss(_ cell: FilterFooterCell) {
        handleDone()
    }
}


