//
//  PostInputText.swift
//  new app 3
//
//  Created by William Hinson on 7/2/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class PostInputText: UITextView {
    
    // MARK: - Properties
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.text = "What's on your mind?"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = UIColor(named: "DefaultBackgroundColor")
        font = UIFont.systemFont(ofSize: 18)
        isScrollEnabled = false
//        heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 8, paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange),
                                               name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
