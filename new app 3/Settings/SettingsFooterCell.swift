//
//  SettingsFooterCell.swift
//  new app 3
//
//  Created by William Hinson on 3/17/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol SettingsFooterDelegate: class {
    func logout(_ cell: SettingsFooterCell)
}

class SettingsFooterCell: UITableViewCell {
    
    weak var delegate: SettingsFooterDelegate?
    
lazy var logoutButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Logout", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = Colors.blackColor
    button.layer.cornerRadius = 20
    button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    return button
}()
    
 override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
   super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(logoutButton)
    logoutButton.centerX(inView: self)
    logoutButton.centerY(inView: self)
    logoutButton.anchor(width: 375, height: 50)
    logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)

}
    
    @objc func handleLogout() {
        delegate?.logout(self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
