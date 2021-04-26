//
//  GigDescription.swift
//  new app 3
//
//  Created by William Hinson on 2/24/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit

class GigDescription: UITableViewCell, UITextViewDelegate {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Description"
        label.textColor = .black
        return label
    }()

    let textView: UITextView = {
       let text = UITextView()
        text.text = "Ex: Looking for a talented musician to play at our venue Friday night."
        text.textColor = .lightGray
        text.font = UIFont.systemFont(ofSize: 16)
        text.layer.borderWidth = 0.5
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.cornerRadius = 5
        text.returnKeyType = .done
        return text
    }()
 
    
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
  super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    textView.delegate = self
    
    self.backgroundColor = .clear
    self.contentView.addSubview(titleLabel)
    titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 18, paddingLeft: 16)
    
    self.contentView.addSubview(textView)
    textView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 8)
}
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Ex: Looking for a talented musician to play at our venue Friday night." {
            textView.text = ""
            textView.textColor = .black
            textView.font = UIFont.systemFont(ofSize: 16)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Ex: Looking for a talented musician to play at our venue Friday night."
            textView.textColor = .lightGray
            textView.font = UIFont.systemFont(ofSize: 14)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
