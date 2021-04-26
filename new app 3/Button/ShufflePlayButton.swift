//
//  ShufflePlayButton.swift
//  audioPlayerApp
//
//  Created by William Hinson on 2/5/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class ShufflePlayButton: UIButton {

    
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
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = frame.size.height/2
        
        setTitleColor(UIColor.white, for: .normal)
        addTarget(self, action: #selector(ShufflePlayButton.buttonPressed), for: .touchUpInside)
        
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
        
    }

    func activateButton(bool: Bool) {
        
        isOn = bool
        
        let color = bool ? UIColor.black : .black
        let title = bool ? "Pause" : "Shuffle"
        let titleColor = bool ? . white : UIColor.white
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }

}
