//
//  FirstTimeInstallationIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/19/20.
//

import UIKit
import Invysta_Framework

final class FirstTimeInstallationIdentifier: IdentifierSource {
    var type: String = IdentifierType.FirstTimeInstallation.rawValue
    
    func identifier() -> String? {
        if let encData = UserDefaults.standard.string(forKey: type) {
            return encData
        } else {
            let currentTimestamp = String(Date().timeIntervalSinceNow)
            let encData = SHA256(data: currentTimestamp.data(using: .utf8))
            UserDefaults.standard.setValue(encData, forKey: type)
            return encData
        }
    }
    
}
