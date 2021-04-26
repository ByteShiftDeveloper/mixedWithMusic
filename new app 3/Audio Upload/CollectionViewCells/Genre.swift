//
//  Genre.swift
//  new app 3
//
//  Created by William Hinson on 7/21/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class Genre: UICollectionViewCell {
    
    lazy var genrelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Select a Genre"
        label.textColor = .white
        return label
    }()
    
   override init(frame: CGRect) {
    super.init(frame: frame)
        
        self.backgroundColor = .clear
        addSubview(genrelabel)
        genrelabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)
        
//        addSubview(titleTextField)
//        titleTextField.anchor(top: genrelabel.bottomAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
