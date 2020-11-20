//
//  FirstTimeInstallationIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/19/20.
//

import UIKit

final class FirstTimeInstallationIdentifier: Identifier, IdentifierSource {
    var type: String = "FirstTimeInstallation"
    
    func identifier() -> String? {
        if let encData = UserDefaults.standard.string(forKey: type) {
            return encData
        } else {
            let currentTimestamp = String(Date().timeIntervalSinceNow)
            return SHA256(data: currentTimestamp.data(using: .utf8))
        }
    }
    
}
