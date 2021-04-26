//
//  NewMessageCell.swift
//  new app 3
//
//  Created by William Hinson on 9/9/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class NewMessageCell: UITableViewCell {
    
    // MARK: - Properties
    
    var delegate: MessageCellDelegate?
    
    var user: User? {
        
        didSet {
            guard let profileImageUrl = user?.profileImageURL else { return }
            guard let username = user?.username else { return }
            guard let fullname = user?.fullname else { return }
            
            profileImageView.loadImage(with: profileImageUrl)
            usernameLabel.text = username
            fullnameLabel.text = fullname
        }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let fullnameLabel: UILabel = {
       let label = UILabel()
        label.text = "Someone's name"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(named: "BlackColor")
        return label
    }()
    
    let usernameLabel: UILabel = {
       let label = UILabel()
        label.text = "Here is a random message to test how this looks"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: "DefaultBackgroundColor")
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(fullnameLabel)
        fullnameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, paddingTop: 4, paddingLeft: 8)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: fullnameLabel.bottomAnchor, left: profileImageView.rightAnchor, paddingTop: 6, paddingLeft: 8)
        
 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 68, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: (textLabel!.frame.height))
        
        detailTextLabel?.frame = CGRect(x: 68, y: detailTextLabel!.frame.origin.y + 2, width: self.frame.width - 108, height: (detailTextLabel?.frame.height)!)
        
        textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        detailTextLabel?.textColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
