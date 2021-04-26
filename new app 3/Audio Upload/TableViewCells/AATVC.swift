//
//  AATVC.swift
//  new app 3
//
//  Created by William Hinson on 7/28/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol AADelegate {
    func addAudio()
}

class AATVC: UITableViewCell {
    
    var delegate: AADelegate?
    
lazy var addAudioButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Song", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.blackColor
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(addAudio), for: .touchUpInside)
        return button
    }()
    
override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    self.backgroundColor = .clear
    addSubview(addAudioButton)
    addAudioButton.anchor(width: 375, height: 50)
    addAudioButton.centerX(inView: self)
}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addAudio() {
        delegate?.addAudio()
    }
}
