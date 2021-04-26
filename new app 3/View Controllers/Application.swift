//
//  Application.swift
//  new app 3
//
//  Created by William Hinson on 2/25/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import Firebase

class Application: UIViewController, UITextViewDelegate {
    
    var text: String? = ""
    
    var selectedLoction: String? = ""
    var selectedGenre: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        
        menu.anchorView = divider1
        self.view.layoutIfNeeded()
        menu.selectionAction = { [weak self] (index, item) in
            self?.titleTextField.text = item
            self?.titleTextField.textColor = .black
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI()
    }
    
    
    //MARK: -UI Implementation
    
    
    
    let gigTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.text = "Give your gig listing a title"
        label.textColor = .black
        return label
    }()
    
    let gigTextView: UITextField = {
       let text = UITextField()
        text.placeholder = "Ex: Musician wanted for live music!"
        text.textColor = .black
        text.font = UIFont.systemFont(ofSize: 16)
        text.returnKeyType = .done
        return text
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.text = "Enter the following information to tell us what your looking for:"
        label.textColor = .black
        return label
    }()
    
    let lookingForLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "What are you looking for?"
        label.textColor = .black
        return label
    }()
    
    let titleTextField: UILabel = {
        let tf = UILabel()
        tf.font = UIFont.systemFont(ofSize: 16)
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
    
    let descriptionTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Description"
        label.textColor = .black
        return label
    }()

    let textView: UITextView = {
       let text = UITextView()
        text.text = "Ex: Looking for a talented musician to play at our venue Friday night."
        text.textColor = .lightGray
        text.font = UIFont.systemFont(ofSize: 16)
        text.layer.borderWidth = 0.5
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.cornerRadius = 5
        text.returnKeyType = .done
        return text
    }()
    
    let uploadButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Post Gig", for: .normal)
      button.setTitleColor(.white, for: .normal)
      button.backgroundColor = Colors.blackColor
      button.layer.cornerRadius = 25
//      button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
      return button
      }()
    
    let menu: DropDown = {
       let menu = DropDown()
        menu.dataSource = ["Artist", "Band", "DJ", "Musician", "Producer"]
        return menu
    }()
    
    let eventTime: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "When will it be taking place?"
        label.textColor = .black
        return label
    }()
    
    let selectTime: UILabel = {
        let tf = UILabel()
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.text = "Ex: March 5th, 7:30 p.m"
        tf.textColor = .lightGray
        return tf
    }()
 
    let divider1 = UIView()
    
    
    func configureUI() {
    
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(gigTitle)
        gigTitle.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(gigTextView)
        gigTextView.anchor(top: gigTitle.bottomAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 16)
        
        let divider = UIView()
        divider.backgroundColor = .systemGroupedBackground
        view.addSubview(divider)
        divider.anchor(top: gigTextView.bottomAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 2, paddingLeft: 16, paddingRight: 16, height: 1)
        
        view.addSubview(eventTime)
        eventTime.anchor(top: divider.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 16)
        
        view.addSubview(selectTime)
        selectTime.anchor(top: eventTime.bottomAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 16)
        
        let divider4 = UIView()
        divider4.backgroundColor = .systemGroupedBackground
        view.addSubview(divider4)
        divider4.anchor(top: selectTime.bottomAnchor, left: view.leftAnchor,
                        right: view.rightAnchor,paddingTop: 2, paddingLeft: 16, paddingRight: 16, height: 1)
        
        
        view.addSubview(lookingForLabel)
        lookingForLabel.anchor(top: divider4.bottomAnchor, left: view.leftAnchor, paddingTop: 18, paddingLeft: 16)
            
        view.addSubview(titleTextField)
        titleTextField.anchor(top: lookingForLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(dropDownaButton)
        dropDownaButton.anchor(top: lookingForLabel.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingRight: 24, width: 15, height: 10)
        dropDownaButton.isUserInteractionEnabled = true
        dropDownaButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
//
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: titleTextField.bottomAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 2, paddingLeft: 16, paddingRight: 16, height: 1)
        

        
        view.addSubview(genrelabel)
        genrelabel.anchor(top: divider1.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 16)

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
        
        let divider2 = UIView()
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
        
        view.addSubview(descriptionTitle)
        descriptionTitle.anchor(top: divider3.bottomAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 16)

        view.addSubview(textView)
        textView.anchor(top: descriptionTitle.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 8, height: 150)
        textView.delegate = self
        
 
        view.addSubview(uploadButton)
        uploadButton.anchor(top: textView.bottomAnchor, paddingTop: 24, width: 375, height: 50)
        uploadButton.centerX(inView: view)
        uploadButton.applyGradient(colors: [UIColor.black.cgColor, Colors.space.cgColor])
        uploadButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
       
        
    }
        
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Ex: Looking for a talented musician to play at our venue Friday night." {
            textView.text = ""
            textView.textColor = .black
            textView.font = UIFont.systemFont(ofSize: 16)
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Ex: Looking for a talented musician to play at our venue Friday night."
            textView.textColor = .lightGray
            textView.font = UIFont.systemFont(ofSize: 14)
        }
    }

    @objc func handleNext() {
       print("NEXT")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let description = textView.text else { return }
        guard let lookingFor = titleTextField.text else { return }
        guard let title = gigTextView.text else { return }
        
        
        
        let values = ["uid": uid,
                      "title" : title,
                      "lookingFor": lookingFor,
                      "location": selectedLoction ?? "",
                      "genre": selectedGenre ?? "",
                      "timestampt": Int(NSDate().timeIntervalSince1970),
                      "text": description] as [String:Any]
        
        let ref = GIGS_REF.childByAutoId()
        ref.updateChildValues(values) { (err, ref) in
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func handleTap() {
        menu.show()
    }
    
    func checkInput() -> Bool {
        
        return true
    }
    
    @objc func handleLocationTap() {
        print("Tapped")
        
        let controller = LocationTableView()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleGenreTap() {
        let controller = SelectGenreTableViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
