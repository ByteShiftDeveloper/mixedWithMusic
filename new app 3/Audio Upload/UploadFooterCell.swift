//
//  UploadFooterCell.swift
//  new app 3
//
//  Created by William Hinson on 7/22/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class UploadFooterCell: UICollectionViewCell {
    
  
    let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.darkGray
    //       button.addTarget(self, action: #selector(handleFollowTap), for: .touchUpInside)
        return button
    }()
    
override init(frame: CGRect) {
    super.init(frame: frame)
        
    self.backgroundColor = .clear
  
    addSubview(uploadButton)
    uploadButton.anchor(top: self.topAnchor, paddingTop: 21, width: 375, height: 50)
    uploadButton.centerX(inView: self)
        
//       addSubview(titleTextField)
//       titleTextField.anchor(top: genrelabel.bottomAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)

}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
