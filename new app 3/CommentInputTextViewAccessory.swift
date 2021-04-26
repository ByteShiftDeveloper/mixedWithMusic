//
//  CommentInputTextViewAccessory.swift
//  new app 3
//
//  Created by William Hinson on 9/15/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class CommentInputTextViewAccessory: UIView {
    
    // MARK: - Properties
    
    var delegate: MessageInputAccesoryViewDelegate?
    
    let CommentInputTextField: commentInputTextField = {
        let tv = commentInputTextField()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.borderWidth = 0.5
        tv.layer.cornerRadius = 16 / 2
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.isScrollEnabled = false
        return tv
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor(named: "BlackColor"), for: .normal)
        button.addTarget(self, action: #selector(handleUploadMessage), for: .touchUpInside)
        return button
    }()
    
    let uploadImageIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.tintColor = UIColor(named: "BlackColor")
        return iv
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        
        backgroundColor = UIColor(named: "DefaultBackgroundColor")
        
        addSubview(sendButton)
        sendButton.anchor1(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 50, height: 35)
        
//        addSubview(uploadImageIcon)
//        uploadImageIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImage)))
//        uploadImageIcon.isUserInteractionEnabled = true
//        uploadImageIcon.anchor1(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 35)
        
        addSubview(CommentInputTextField)
        CommentInputTextField.anchor1(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor1(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearMessageTextView() {
        CommentInputTextField.placeholderLabel.isHidden = false
        CommentInputTextField.text = nil
    }
    
    // MARK: - Handlers
    
    @objc func handleUploadMessage() {
        guard let message = CommentInputTextField.text else { return }
        delegate?.handleUploadMessage(message: message)
    }
    
    @objc func handleSelectImage() {
        delegate?.handleSelectImage()
    }
}
