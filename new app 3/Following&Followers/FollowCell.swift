//
//  FollowCell.swift
//  new app 3
//
//  Created by William Hinson on 7/2/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol FollowCellDelegate: class {
    func handleEditProfileFollow(_ cell: FollowCell)
}

class FollowCell: UITableViewCell {
    
    var delegate: FollowCellDelegate?
    
    var user: User? {
        didSet {
            guard let fullname = user?.fullname else { return }
            guard let profileImageURl = user?.profileImageURL else { return }
            let viewModel = ProfileHeaderViewModel(user: user!)
            followButton.setTitle(viewModel.actionButtonTitle, for: .normal)
            profileImageView.loadImage(with: profileImageURl)
            usernameLabel.text = fullname
        }
    }
    
     private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 50, height: 50)
        iv.layer.cornerRadius = 50 / 2
        iv.backgroundColor = .lightGray
//       let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
//       iv.addGestureRecognizer(tap)
       iv.isUserInteractionEnabled = true
              return iv
          }()
    
    let usernameLabel: UILabel = {
           let label = UILabel()
           label.numberOfLines = 1
           label.font = UIFont.boldSystemFont(ofSize: 16)
           label.text = "Allen Hinson"
           return label
       }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.25
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, usernameLabel])
        stack.spacing = 8
        stack.alignment = .center
             
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        stack.anchor(right: rightAnchor, paddingRight: 12)
    
        
        addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.setDimensions(width: 88, height: 32)
        followButton.layer.cornerRadius = 32 / 2
        followButton.anchor(right: rightAnchor, paddingRight: 12)
        
//        textLabel?.text = "username"
//        
//        detailTextLabel?.text = "Full Name"
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        textLabel?.frame = CGRect(x: 68, y: textLabel!.frame.origin.y - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
//        textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
//
//        detailTextLabel?.frame = CGRect(x: 68, y: detailTextLabel!.frame.origin.y, width: self.frame.width - 108, height: detailTextLabel!.frame.height)
//        detailTextLabel?.textColor = .lightGray
//        detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
//    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleEditProfileFollow() {
        delegate?.handleEditProfileFollow(self)
    }

}
