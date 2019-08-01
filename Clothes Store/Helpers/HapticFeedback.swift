//
//  HapticFeedback.swift
//  Clothes Store
//
//  Created by Richard Hope on 31/07/2019.
//  Copyright © 2017 Richard Hope. All rights reserved.
//

import UIKit
import AudioToolbox

class Haptic {
    
    class func feedBack(){
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        AudioServicesPlaySystemSound(1104)
    }
}


