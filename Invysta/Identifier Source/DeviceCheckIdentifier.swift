//
//  DeviceCheckIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/9/20.
//

import UIKit
import DeviceCheck
import CoreTelephony

class DeviceCheckIdentifier: Identifier, IdentifierSource {
    var type: String = "DeviceCheck"
    
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
        let val = Data(base64Encoded: deviceName + languageCode + regionCode + calendarIdentifier + timeZone)
        return SHA256(data: val)
    }
    
}