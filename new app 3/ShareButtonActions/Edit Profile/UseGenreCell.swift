//
//  UseGenreCell.swift
//  new app 3
//
//  Created by William Hinson on 10/19/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol UserGenreCellDelegate: class {
    func pickerSelect(_ cell: UserGenreCell)
}

class UserGenreCell: UITableViewCell {
    
    var user: User? {
        didSet { configureUI() }
    }
    
    weak var delegate: UserGenreCellDelegate?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    
    let GenreLabel: UILabel = {
       let label =  UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    
    let editButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        return button
    }()

    
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
  super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
    self.contentView.addSubview(titleLabel)
    titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    titleLabel.anchor(left: leftAnchor, paddingLeft: 16)
    titleLabel.centerY(inView: self.contentView)
    
   
    addSubview(editButton)
    editButton.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
    editButton.addTarget(self, action: #selector(handlePickerSelect), for: .touchUpInside)

    
    self.contentView.addSubview(GenreLabel)
    GenreLabel.anchor(right: editButton.leftAnchor, paddingRight: 8)
    GenreLabel.centerY(inView: self.contentView)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePickerSelect() {
        delegate?.pickerSelect(self)
    }
    
    func configureUI() {
        titleLabel.text = "Your genres"
        GenreLabel.text = user?.genre
    }

}
