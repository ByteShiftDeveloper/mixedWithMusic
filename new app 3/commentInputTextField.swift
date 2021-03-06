//
//  commentInputTextField.swift
//  new app 3
//
//  Created by William Hinson on 9/15/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class commentInputTextField: UITextView {
    
    // MARK: - Properties
        let placeholderLabel: UILabel = {
            let label = UILabel()
            label.text = "Enter comment.."
            label.textColor = .lightGray
            return label
        }()
        
        // MARK: - Init
        
        override init(frame: CGRect, textContainer: NSTextContainer?) {
            super.init(frame: frame, textContainer: textContainer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleInputTextChange), name: UITextView.textDidChangeNotification, object: nil)
            
            addSubview(placeholderLabel)
            placeholderLabel.anchor1(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Handlers
        
        @objc func handleInputTextChange() {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
