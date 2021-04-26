//
//  AddAudioTVC.swift
//  new app 3
//
//  Created by William Hinson on 7/24/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol AddAudioDelegate {
    func addAudio()
}

class AddAudioTVC: UITableViewCell {
    
    var delegate: AddAudioDelegate?
    
    let addAudioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Audio"
        label.textColor = .black
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Select your audio file to upload"
        label.textColor = .black
        return label
    }()
    
    let audioName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = ""
        label.textColor = .lightGray
        return label
    }()
    
lazy var addAudioButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Audio", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.blackColor
        button.layer.cornerRadius = 25
        button.tag = 10
        button.addTarget(self, action: #selector(addAudioPressed), for: .touchUpInside)
//    button.isUserInteractionEnabled = true
        return button
    }()
    
override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    self.backgroundColor = .clear
    addSubview(addAudioLabel)
    addAudioLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)
    
    self.contentView.addSubview(descriptionLabel)
    descriptionLabel.anchor(top: addAudioLabel.bottomAnchor, left: self.leftAnchor, paddingTop: 2, paddingLeft: 16)
    
    self.contentView.addSubview(audioName)
    audioName.anchor(top: descriptionLabel.bottomAnchor, left: self.leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16)
    
    self.contentView.addSubview(addAudioButton)
    addAudioButton.anchor(top: audioName.bottomAnchor, paddingTop: 8, width: 375, height: 50)
    addAudioButton.centerX(inView: self)
    addAudioButton.applyGradient(colors: [UIColor.black.cgColor, Colors.space.cgColor])

    
//       addSubview(titleTextField)
//       titleTextField.anchor(top: genrelabel.bottomAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)

}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addAudioPressed() {
        delegate?.addAudio()
    }
}
