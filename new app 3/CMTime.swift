//
//  CMTime.swift
//  new app 3
//
//  Created by William Hinson on 10/8/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatString = String(format: "%02d:%02d", minutes,seconds)
        return timeFormatString
    }
}
