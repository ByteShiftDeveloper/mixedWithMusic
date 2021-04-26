//
//  Pulsate.swift
//  new app 3
//
//  Created by William Hinson on 2/29/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.75
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
}
