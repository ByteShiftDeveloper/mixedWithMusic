//
//  EditProfileHeader.swift
//  new app 3
//
//  Created by William Hinson on 9/11/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol EditProfileDelegate: class {
    func chooseImage1(_ header: EditProfileHeader)
    func chooseImage2(_ header: EditProfileHeader)
}

class EditProfileHeader: UIView {
    
    private let user: User
    weak var delegate: EditProfileDelegate?
    
    var imagePicked = 0


    
    
  let containerView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
//        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
//        backButton.setDimensions(width: 30, height: 30)
        return view
    }()
    
let profileImageView: UIImageView = {
       let iv = UIImageView()
       iv.contentMode = .scaleAspectFill
       iv.clipsToBounds = true
       iv.backgroundColor = .lightGray
       iv.layer.borderColor = UIColor.white.cgColor
       iv.layer.borderWidth = 4
       return iv
       
   }()

 let profilePicSelect: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .white
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
//           button.setDimensions(width: 18, height: 16)
        button.tag = 1
        button.addTarget(self, action: #selector(chooseImage1), for: .touchUpInside)
        return button
       }()
    
 let headerPicSelect: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .white
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tag = 2
//           button.setDimensions(width: 18, height: 16)
        button.addTarget(self, action: #selector(chooseImage2), for: .touchUpInside)
        return button
       }()
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 200)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, paddingTop: -50, paddingLeft: 8)
        profileImageView.centerX(inView: containerView)
        profileImageView.setDimensions(width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100 / 2
        
        addSubview(profilePicSelect)
        profilePicSelect.anchor(width: 25, height: 25)
        profilePicSelect.center(inView: profileImageView)
        imagePicked = profilePicSelect.tag
        
        addSubview(headerPicSelect)
        headerPicSelect.anchor(width: 25, height: 25)
        headerPicSelect.center(inView: containerView)
        imagePicked = headerPicSelect.tag

        
        
        
        profileImageView.loadImage(with: user.profileImageURL)
        if user.headerImageURL == nil {
            let headerImageUrl = "https://firebasestorage.googleapis.com/v0/b/mixed-with-music-28704.appspot.com/o/users%2Fprofile%2FStandard%20Header%2FDeep%20Space.jpg?alt=media&token=ccf92ddb-604a-45a2-9e6c-8d21029c726f"
            containerView.loadImage(with: headerImageUrl)

        } else if user.headerImageURL != nil {
            guard let headerImageUrl = user.headerImageURL else { return }
            containerView.loadImage(with: headerImageUrl)

        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func chooseImage1() {
        delegate?.chooseImage1(self)
//        imagePicked = profilePicSelect.tag
        print("tapped")

    }
    
    @objc func chooseImage2() {
        delegate?.chooseImage2(self)
//        imagePicked = headerPicSelect.tag
        print("tapped")

    }
    
}
