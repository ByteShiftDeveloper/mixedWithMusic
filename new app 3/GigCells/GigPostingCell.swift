//
//  GigPostingCell.swift
//  new app 3
//
//  Created by William Hinson on 2/26/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit


class GigPostingCell: UITableViewCell {
    
    var gig: Gigs? {
        didSet { configureUI()

        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 50, height: 50)
        iv.layer.cornerRadius = 50 / 2
        iv.backgroundColor = .lightGray
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Peter Parker"
        label.isUserInteractionEnabled = true
        label.textColor = UIColor(named: "BlackColor")
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Musician Needed"
        label.isUserInteractionEnabled = true
        label.textColor = UIColor(named: "BlackColor")
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "15 minutes ago"
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "San Antonio, TX, United States"
        return label
    }()

    
    let postTextLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .black
        label.mentionColor = Colors.activelabelblue
        label.hashtagColor = Colors.activelabelblue
        return label
    }()


    
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
  super.init(style: style, reuseIdentifier: reuseIdentifier)
    
//    let stack2 = UIStackView(arrangedSubviews: [locationLabel, timestampLabel])
//    stack2.spacing = 12
//
//    let labelStack = UIStackView(arrangedSubviews: [titleLabel, fullnameLabel, locationLabel])
//    labelStack.axis = .vertical
//    labelStack.spacing = 0
//
//    let stack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
//    stack.spacing = 12
//
//    self.contentView.addSubview(stack)
//    stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
    
    self.contentView.addSubview(profileImageView)
    profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
    
    self.contentView.addSubview(titleLabel)
    titleLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, paddingTop: 16, paddingLeft: 12)
    
    self.contentView.addSubview(fullnameLabel)
    fullnameLabel.anchor(top: titleLabel.bottomAnchor, left: profileImageView.rightAnchor, paddingTop: 0, paddingLeft: 12)
    
    self.contentView.addSubview(locationLabel)
    locationLabel.anchor(top: fullnameLabel.bottomAnchor, left: profileImageView.rightAnchor, paddingTop: 0, paddingLeft: 12)
    
    self.contentView.addSubview(timestampLabel)
    timestampLabel.anchor(top: locationLabel.bottomAnchor, left: locationLabel.leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 16)
    
    let divider3 = UIView()
    divider3.backgroundColor = .tertiarySystemGroupedBackground
    self.contentView.addSubview(divider3)
    divider3.anchor(top: timestampLabel.bottomAnchor, left: titleLabel.leftAnchor,
                    right: rightAnchor,paddingTop: 6, paddingLeft: 0, paddingRight: 16, height: 1)


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        let url = URL(string: (gig?.user.profileImageURL)!)
        profileImageView.kf.setImage(with: url)
        
        fullnameLabel.text = gig?.user.fullname
        timestampLabel.text = gig?.createdAt.calenderTimeSinceNow()
        postTextLabel.text = gig?.text
        locationLabel.text = gig?.location
        titleLabel.text = gig?.title
    }

}
