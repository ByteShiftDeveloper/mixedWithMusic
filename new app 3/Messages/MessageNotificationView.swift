//
//  MessageNotificationView.swift
//  new app 3
//
//  Created by William Hinson on 4/25/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class MessageNotificationView: UIView {

    // MARK: - Properties
    
    var notificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
        
        addSubview(notificationLabel)
        notificationLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        notificationLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

