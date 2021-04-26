//
//  GigApplication.swift
//  new app 3
//
//  Created by William Hinson on 2/24/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import Foundation
import Firebase
import DropDown


private let reuseIdentifer = "reuseIdent"
private let reuseIdentifer2 = "reuseIdent2"
private let reuseIdentifer3 = "reuseIdent3"
private let reuseIdentifer4 = "reuseIdent4"
private let reuseIdentifer5 = "reuseIdent5"
private let reuseIdentifer6 = "reuseIdent6"

class GigApplication: UITableViewController {

    var selectedGenres : [String] = []
    var selectedGenreArr : [String] = []
    var lookingCell: LookingForTVC?
    var datePicker = UIDatePicker()
    var datePickerConstraints = [NSLayoutConstraint]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.separatorStyle = .none
        self.tableView.register(LookingForTVC.self, forCellReuseIdentifier: reuseIdentifer)
        self.tableView.register(GigGenre.self, forCellReuseIdentifier: reuseIdentifer2)
        self.tableView.register(GigDescription.self, forCellReuseIdentifier: reuseIdentifer3)
        self.tableView.register(GigLocation.self, forCellReuseIdentifier: reuseIdentifer4)
        self.tableView.register(GigTitle.self, forCellReuseIdentifier: reuseIdentifer5)
        self.tableView.register(GigTime.self, forCellReuseIdentifier: reuseIdentifer6)
        configNavBar()
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        tableView.reloadData()
    }
    
    let headerView : UIView = {
       let view = UIView()
        let label : UILabel = {
           let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textColor = .black
            label.numberOfLines = 2
            label.textAlignment = .left
            label.text = "Enter the following information to tell us what your looking for:"
            return label
        }()
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        return view
    }()
    
    let footerView : UIView = {
       let view = UIView()
        
        let uploadButton: UIButton = {
              let button = UIButton(type: .system)
              button.setTitle("Post Gig", for: .normal)
              button.setTitleColor(.white, for: .normal)
              button.backgroundColor = Colors.blackColor
              button.layer.cornerRadius = 25
                 button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
              return button
          }()
    
        
        view.addSubview(uploadButton)
        uploadButton.anchor(width: 375, height: 50)
        uploadButton.centerY(inView: view)
        uploadButton.centerX(inView: view)
        uploadButton.applyGradient(colors: [UIColor.black.cgColor, Colors.space.cgColor])
        
        return view
    }()


//    func createDatePicker() {
//
//
//        self.datePicker.frame = CGRect(x: 0, y: 400, width:self.view.frame.size.width, height: 200)
//        self.view.addSubview(datePicker)
//
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
//    }


    func configNavBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
//        navigationItem.title = "Create a gig"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
//        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.tintColor = .black
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    @objc func handleNext() {
        let cell1 = tableView.cellForRow(at: [0,0]) as! GigTitle
        let cell2 = tableView.cellForRow(at: [1,0]) as! GigTime
        let cell3 = tableView.cellForRow(at: [2,0]) as! LookingForTVC
        let cell4 = tableView.cellForRow(at: [3,0]) as! GigGenre
        let cell5 = tableView.cellForRow(at: [4,0]) as! GigLocation
        let cell6 = tableView.cellForRow(at: [5,0]) as! GigDescription
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let description = cell6.textView.text else { return }
        guard let lookingFor = cell3.titleTextField.text else { return }
        guard let title = cell1.gigTextView.text else { return }
        guard let selectedLoction = cell5.location.text else { return }
        guard let genres = cell4.genre.text else { return }
        guard let date = cell2.selectTime.text else { return }
        
        
        
        
        let values = ["uid": uid,
                      "title" : title,
                      "lookingFor": lookingFor,
                      "location": selectedLoction,
                      "genre": genres,
                      "eventTime" : date,
                      "timestampt": Int(NSDate().timeIntervalSince1970),
                      "text": description] as [String:Any]
        
        let ref = GIGS_REF.childByAutoId()
        ref.updateChildValues(values) { (err, ref) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let cell = tableView.cellForRow(at: [4,0]) as! GigLocation
        
        if LocationTableView.location != "" {
            cell.location.text = LocationTableView.location
            cell.location.textColor = .black
        } else {
            cell.location.text = "Ex: San Antonio, TX, United States"
            cell.location.textColor = .black
        }
        
        let cell2 = tableView.cellForRow(at: [1,0]) as! GigTime
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        cell2.selectTime.text = formatter.string(from: cell2.datePicker.date)
    }
}

extension GigApplication {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! LookingForTVC
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.delegate = self
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer2, for: indexPath) as! GigGenre
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.delegate = self
            if selectedGenres.count > 0 {
                cell.genre.text = selectedGenres.joined(separator: ", ")
                cell.genre.textColor = .black
            }else{
                cell.genre.text = "Ex: Dance, EDM, Hip-Hop"
                cell.genre.textColor = .lightGray
            }

            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer4, for: indexPath) as! GigLocation
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.delegate = self
//            if LocationTableView.location != "" {
//                cell.location.text = LocationTableView.location
//            } else {
//                cell.location.text = "San Antonio, TX, United States"
//            }
            return cell
        } else if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer5, for: indexPath) as! GigTitle
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer6, for: indexPath) as! GigTime
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer3, for: indexPath) as! GigDescription
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 5 {
            return 175
        }
        return 75
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 3 {
//            let controller = YourGenresTableView()
//            navigationController?.pushViewController(controller, animated: true)
//            controller.selectedGenreArr = selectedGenres
//            controller.didSelectGenre = { genres in
//                print("genre count :\(genres?.count)")
//                if let genre = genres{
//                    self.selectedGenres = genre
//                    self.tableView.reloadData()
//                }
//            }
//        }
//    }
}

extension GigApplication: LookingForDelegate {
    func handleTap(_ cell: LookingForTVC) {
        cell.menu.show()
    }
}

extension GigApplication: LocationDelegate {
    func handleTap(_ cell: GigLocation) {
        let controller = LocationTableView()
        navigationController?.pushViewController(controller, animated: true)

    }
}

extension GigApplication: GenreDelegate {
    func handleTap(_ cell: GigGenre) {
        let controller = YourGenresTableView()
        navigationController?.pushViewController(controller, animated: true)
        controller.selectedGenreArr = selectedGenres
        controller.didSelectGenre = { genres in
            print("genre count :\(genres?.count)")
            if let genre = genres{
                self.selectedGenres = genre
                self.tableView.reloadData()
            }
        }
    }
}

extension GigApplication: TimeDelegate {
    func handleTap(_ cell: GigTime) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        cell.selectTime.text = formatter.string(from: cell.datePicker.date)
  
    }
}
