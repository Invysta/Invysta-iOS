//
//  DeviceCheckIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/9/20.
//

import UIKit
import DeviceCheck
import CoreTelephony
import Invysta_Framework

struct DeviceCheckIdentifier: IdentifierSource {
    var type: String = IdentifierType.DeviceCheck.rawValue
    
    let deviceName: String = {
        return UIDevice.current.name
    }()
    
    let languageCode: String = {
        return Locale.current.languageCode ?? "language-code-na"
    }()
    
    let regionCode: String = {
        return Locale.isoRegionCodes.joined()
    }()
    
    let calendarIdentifier: String = {
        return "\(Locale.current.calendar.identifier)"
    }()
    
    let timeZone: String = {
        return "\(TimeZone.current.identifier)"
    }()
    
    func identifier() -> String? {
        if let encData = UserDefaults.standard.string(forKey: type) {
            return encData
        } else {
            let val = deviceName + languageCode + regionCode + calendarIdentifier + timeZone
            let encData = SHA256(data: val.data(using: .utf8))
            UserDefaults.standard.setValue(encData, forKey: type)
            return encData
        }
        
    }
    
}
