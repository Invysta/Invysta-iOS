//
//  AccessibilityIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/9/20.
//

import UIKit
import InvystaCore

struct AccessibilityIdentifier: IdentifierSource {
    var type: String = IdentifierType.AccessibilitySettings.rawValue
    
    let isBoldTextEnabled: String = {
        return "\(NSNumber(value: UIAccessibility.isBoldTextEnabled))"
    }()
    
    let isShakeToUndoEnabled: String = {
        return "\(NSNumber(value: UIAccessibility.isShakeToUndoEnabled))"
    }()
    
    let isReduceMotionEnabled: String = {
        return "\(NSNumber(value: UIAccessibility.isReduceMotionEnabled))"
    }()
    
    let isDarkerSystemColorsEnabled: String = {
        return "\(NSNumber(value: UIAccessibility.isDarkerSystemColorsEnabled))"
    }()
    
    let isReduceTransparencyEnabled: String = {
        return "\(NSNumber(value: UIAccessibility.isReduceTransparencyEnabled))"
    }()
    
    let isAssistiveTouchRunning: String = {
        return "\(NSNumber(value: UIAccessibility.isAssistiveTouchRunning))"
    }()
    
    func identifier() -> String? {
        if let val = KeychainWrapper.standard.string(forKey: type) {
            return val
        } else {
            let val = isBoldTextEnabled + isShakeToUndoEnabled + isReduceMotionEnabled + isDarkerSystemColorsEnabled + isReduceTransparencyEnabled + isAssistiveTouchRunning
            KeychainWrapper.standard.set(val, forKey: type)
            return val
        }
    }
    
}
