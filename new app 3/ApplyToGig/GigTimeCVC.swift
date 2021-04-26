//
//  GigTimeCVC.swift
//  new app 3
//
//  Created by William Hinson on 3/5/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit

class GigTimeCVC: UICollectionViewCell {
    
    var gigs: Gigs? {
        didSet {
            titleLabel.text = "Event time: " + gigs!.time
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Gig Time: "
        label.textColor = .black
        return label
    }()

    let textView: UILabel = {
       let text = UILabel()
        text.textColor = .black
        text.font = UIFont.systemFont(ofSize: 16)
        return text
    }()
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        backgroundColor = .red
    
        
    self.backgroundColor = .clear
    self.contentView.addSubview(titleLabel)
    titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: titleLabel.bottomAnchor, left: leftAnchor,
                       right: rightAnchor, paddingTop: 2, paddingLeft: 16, paddingRight: 16, height: 0.25)
//
//    self.contentView.addSubview(textView)
//    textView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 8)
}
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == "Ex: Looking for a talented musician to play at our venue Friday night." {
//            textView.text = ""
//            textView.textColor = .black
//            textView.font = UIFont.systemFont(ofSize: 16)
//        }
//    }
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            textView.resignFirstResponder()
//        }
//        return true
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text == "" {
//            textView.text = "Ex: Looking for a talented musician to play at our venue Friday night."
//            textView.textColor = .lightGray
//            textView.font = UIFont.systemFont(ofSize: 14)
//        }
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
