//
//  AddSongTVC.swift
//  new app 3
//
//  Created by William Hinson on 7/28/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol AddSong {
    func addAudio()
}

class AddSongTVC: UITableViewCell {
    
    var delegate: AddSong?
    
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
    self.contentView.addSubview(addAudioButton)
    addAudioButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 19.5, paddingLeft: 19, width: 374, height: 56)
    addAudioButton.applyGradient(colors: [UIColor.black.cgColor, Colors.space.cgColor])
}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addAudio() {
        delegate?.addAudio()
    }
}
