//
//  FollowButton.swift
//  new app 3
//
//  Created by William Hinson on 1/19/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class FollowButton: UIButton {
    

    var isOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        layer.borderWidth = 2.0
        layer.borderColor = Colors.blackColor.cgColor
        layer.cornerRadius = frame.size.height/2
        
        setTitleColor(Colors.blackColor, for: .normal)
        addTarget(self, action: #selector(FollowButton.buttonPressed), for: .touchUpInside)
        
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
        
    }
    
    
    
    func activateButton(bool: Bool) {
        
        isOn = bool
        
        let color = bool ? Colors.blackColor : .clear
        let title = bool ? "Following" : "Follow"
        let titleColor = bool ? . white : Colors.blackColor
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }
}
