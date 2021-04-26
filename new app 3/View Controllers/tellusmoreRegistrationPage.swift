//
//  tellusmoreRegistrationPage.swift
//  new app 3
//
//  Created by William Hinson on 3/18/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import DropDown


class tellusmoreRegistrationPage: UIViewController {
    
    var selectedLoction: String? = ""
    var selectedGenre: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        
      
        
        menu.anchorView = divider
        self.view.layoutIfNeeded()
        menu.selectionAction = { [weak self] (index, item) in
            self?.titleTextField.text = item
            self?.titleTextField.textColor = .black
        }
        
        if titleTextField.text == "A&R" || titleTextField.text == "Venue" {
            genre.isHidden = true
            genrelabel.isHidden = true
        } else {
            genre.isHidden = false
            genrelabel.isHidden = false
        }
    }
    
    let mainTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 2
        label.text = "Tell us more about yourself"
        label.textColor = .black
        return label
    }()
    
    let backButton: UIButton = {
      let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
      button.setTitleColor(.black, for: .normal)
      return button
      }()
    
    let lookingForLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "What do you consider yourself?"
        label.textColor = .black
        return label
    }()
    
    let titleTextField: UILabel = {
        let tf = UILabel()
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.text = "Select a category"
        tf.textColor = .lightGray
        return tf
    }()
    
    let dropDownaButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let genrelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Select a preferred genre (optional)"
        label.textColor = .black
        return label
    }()
    
    let genre: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
//        label.text = "Ex: Alternative"
        label.textColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGenreTap))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let menu: DropDown = {
       let menu = DropDown()
        menu.dataSource = ["Artist", "A&R", "Band", "DJ", "Musician", "Producer", "Venue"]
        return menu
    }()
    
    let divider = UIView()
    let divider2 = UIView()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Please select your location"
        label.textColor = .black
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLocationTap))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()

    let location: UITextField = {
        let text = UITextField()
        text.text = "San Antonio, TX, United States"
         text.textColor = .black
         text.font = UIFont.systemFont(ofSize: 16)
         text.returnKeyType = .done
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLocationTap))
        text.addGestureRecognizer(tap)
        text.isUserInteractionEnabled = true

        return text
    }()
    
    func configureUI() {
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        backButton.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        
        view.addSubview(mainTitle)
        mainTitle.anchor(top: backButton.bottomAnchor, paddingTop: 16)
        mainTitle.centerX(inView: view)
        
        view.addSubview(lookingForLabel)
        lookingForLabel.anchor(top: mainTitle.bottomAnchor, left: view.leftAnchor, paddingTop: 32, paddingLeft: 16)
            
        view.addSubview(titleTextField)
        titleTextField.anchor(top: lookingForLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(dropDownaButton)
        dropDownaButton.anchor(top: lookingForLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 24, width: 15, height: 10)
        dropDownaButton.isUserInteractionEnabled = true
        dropDownaButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
//
        divider.backgroundColor = .systemGroupedBackground
        view.addSubview(divider)
        divider.anchor(top: titleTextField.bottomAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 2, paddingLeft: 16, paddingRight: 16, height: 1)
        
        view.addSubview(genrelabel)
        genrelabel.anchor(top: divider.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 16)

        view.addSubview(genre)
        genre.anchor(top: genrelabel.bottomAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 16)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handleGenreTap))
        genre.addGestureRecognizer(tap1)
        genre.isUserInteractionEnabled = true
        if SelectGenreTableViewController.genreLabel != "" {
            genre.text = SelectGenreTableViewController.genreLabel
            genre.textColor = .black
            selectedGenre = SelectGenreTableViewController.genreLabel
        } else {
            genre.text = "Ex: Alternative"
            genre.textColor = .lightGray
            selectedGenre = ""
        }
        
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(top: genre.bottomAnchor, left: view.leftAnchor,
                        right: view.rightAnchor,paddingTop: 2, paddingLeft: 16, paddingRight: 16, height: 1)
        
        view.addSubview(locationLabel)
        locationLabel.anchor(top: divider2.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 16)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLocationTap))
        locationLabel.addGestureRecognizer(tap)
        locationLabel.isUserInteractionEnabled = true

        view.addSubview(location)
        location.anchor(top: locationLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 16)
        location.addGestureRecognizer(tap)
        location.isUserInteractionEnabled = true
        if LocationTableView.location != "" {
            location.text = LocationTableView.location
            location.textColor = .black
            selectedLoction = LocationTableView.location
        } else {
            location.text = "San Antonio, TX, United States"
            location.textColor = .lightGray
            selectedLoction = ""
        }
        
     
        
        let divider3 = UIView()
        divider3.backgroundColor = .systemGroupedBackground
        view.addSubview(divider3)
        divider3.anchor(top: location.bottomAnchor, left: view.leftAnchor,
                        right: view.rightAnchor,paddingTop: 2, paddingLeft: 16, paddingRight: 16, height: 1)
        
        
    }
    

    
    @objc func handleBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleLocationTap() {
        print("Tapped")
        
        let controller = LocationTableView()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleGenreTap() {
//        let controller = RegistrationGenres()
//        navigationController?.pushViewController(controller, animated: true)
//        if genre.text != ""{
//            controller.selectedGenreArr = selectedGenres
//        }
//        controller.didSelectGenre = { [self] selectedGenre in
//            if let genre = selectedGenre{
//                self.genre.text = genre.joined(separator: ", ")
//            }
//        }

    }
    
    @objc func handleTap() {
        menu.show()
    }

    
}
