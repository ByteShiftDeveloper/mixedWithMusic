//
//  SelectedPostHeader.swift
//  new app 3
//
//  Created by William Hinson on 5/15/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class SelectedPostHeader: UICollectionReusableView {
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
           @IBOutlet weak var usernameLabel: UILabel!
           
           @IBOutlet weak var unlikeButton: UIButton!
           
           @IBOutlet weak var profileImageView: UIImageView!
           
           @IBOutlet weak var subtitleLabel: UILabel!
           
           @IBOutlet weak var postTextLabel: UILabel!
           
           @IBOutlet weak var postImage: UIImageView!
           
           @IBOutlet weak var likeButton: UIButton!
           @IBOutlet weak var commentButton: UIButton!
           
           @IBOutlet weak var likeCountLabel: UILabel!
           @IBOutlet weak var shareButton: UIButton!
        @IBOutlet weak var showLikeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
