//
//  WAYUViewController.swift
//  new app 3
//
//  Created by William Hinson on 7/15/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class WAYUViewController: UIViewController {
    
    var user: User? {
             didSet {
           }
         }
    
    lazy var wayuLabel: UILabel = {
        let lb = UILabel()
        lb.text = "What are you uploading?"
        lb.font = UIFont.boldSystemFont(ofSize: 24)
        lb.textAlignment = .center
        lb.textColor = UIColor(named: "BlackColor")
        return lb
    }()
    
    lazy var singleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "A Single"
        lb.font = UIFont.boldSystemFont(ofSize: 24)
        lb.textAlignment = .center
        lb.textColor = UIColor(named: "BlackColor")
        return lb
    }()
    
    lazy var singleDescroptionLabel: UILabel = {
        let lb = UILabel()
        lb.text = "We know definitions may vary, but we consider a single just one song in this instance. If you are uploading more than one song please check the option below."
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.textColor = UIColor(named: "BlackColor")
        return lb
    }()
    
    lazy var singleButton: UIButton = {
        let button = UIButton()
        button.setDimensions(width: 80, height: 50)
        button.setTitle("Upload Single", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.blackColor
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handleSingle), for: .touchUpInside)
        return button
    }()
    
    lazy var epLabel: UILabel = {
           let lb = UILabel()
           lb.text = "An EP or Album"
           lb.font = UIFont.boldSystemFont(ofSize: 24)
           lb.textAlignment = .center
           lb.textColor = UIColor(named: "BlackColor")
           return lb
       }()
       
       lazy var epDescroptionLabel: UILabel = {
           let lb = UILabel()
           lb.text = "If you are uploading more than one song select this option. If you are uploading a single please see the option above."
           lb.font = UIFont.boldSystemFont(ofSize: 14)
           lb.numberOfLines = 0
           lb.textAlignment = .center
           lb.textColor = UIColor(named: "BlackColor")
           return lb
       }()
       
       lazy var epButton: UIButton = {
           let button = UIButton()
           button.setDimensions(width: 80, height: 50)
           button.setTitle("Upload EP or Album", for: .normal)
           button.setTitleColor(.white, for: .normal)
           button.backgroundColor = Colors.blackColor
           button.layer.cornerRadius = 25
           button.addTarget(self, action: #selector(handleEP), for: .touchUpInside)
           return button
       }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "DefaultBackgroundColor")
        configureUI()
        print("this is wayu controller")
        singleButton.applyGradient(colors: [Colors.color1!.cgColor, Colors.color2!.cgColor])
        epButton.applyGradient(colors: [UIColor.black.cgColor, Colors.space.cgColor])
    }
    
  
    
    func configureUI() {
//        view.addSubview(wayuLabel)
//        wayuLabel.anchor(top: view.topAnchor, paddingTop: 16)
//        wayuLabel.centerX(inView: view)
//
//        view.addSubview(singleLabel)
//        singleLabel.anchor(top: wayuLabel.bottomAnchor, paddingTop: 16)
//        singleLabel.centerX(inView: view)
//
//        view.addSubview(singleDescroptionLabel)
//        singleDescroptionLabel.anchor(top: singleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32 )
        
  
        let userDetailStack = UIStackView(arrangedSubviews: [wayuLabel, singleLabel, singleDescroptionLabel, singleButton, epLabel, epDescroptionLabel, epButton])
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 12
    
        
        view.addSubview(userDetailStack)
        userDetailStack.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)
        userDetailStack.centerX(inView: view)
        
        let epAlbumStack = UIStackView(arrangedSubviews: [epLabel, epDescroptionLabel, epButton])
        epAlbumStack.axis = .vertical
        epAlbumStack.distribution = .fillProportionally
        epAlbumStack.spacing = 12
        
        view.addSubview(epAlbumStack)
        epAlbumStack.anchor(top: userDetailStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)
        epAlbumStack.centerX(inView: view)
        
        
    }
    
    
    @objc func handleSingle() {
        print("tapped")
        let controller = SingleUploadTableViewController()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleEP() {
        print("tapped")
        let controller = MultipleSongsTableViewController()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
}
