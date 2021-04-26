//
//  GigGenre.swift
//  new app 3
//
//  Created by William Hinson on 2/24/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol GenreDelegate {
    func handleTap(_ cell: GigGenre)
}

class GigGenre: UITableViewCell {
    
    var delegate: GenreDelegate?
    
    var selectedGenres : [String] = []
    var selectedGenreArr : [String] = []

    
    let genrelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Select a preferred genre (up to three)"
        label.textColor = .black
        return label
    }()
    
    let genre: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Ex: Alternative"
        label.textColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    
 override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
   super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    self.backgroundColor = .clear
    self.contentView.addSubview(genrelabel)
    genrelabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 18, paddingLeft: 16)

    self.contentView.addSubview(genre)
    genre.anchor(top: genrelabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    genre.isUserInteractionEnabled = true
    genre.addGestureRecognizer(tap)

    
    let divider = UIView()
    divider.backgroundColor = .systemGroupedBackground
    self.contentView.addSubview(divider)
    divider.anchor(left: leftAnchor, bottom: bottomAnchor,
                   right: rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, height: 1)
    
//        addSubview(titleTextField)
//        titleTextField.anchor(top: genrelabel.bottomAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)

}
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap() {
        delegate?.handleTap(self)
    }
}
