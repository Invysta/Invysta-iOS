//
//  LocalIdentifierManager.swift
//  Invystas-macOS
//
//  Created by Cyril Garcia on 5/25/21.
//

import Foundation
import InvystaCore

final class LocalIdentifierManager {
    
    static func resetIdentifiers() {
        LocalIdentifierManager.clearIdentifiers()
        LocalIdentifierManager.configure()
    }
    
    static func configure() {
        IdentifierManager.configure([AccessibilityIdentifier(),
                                     CellularIdentifier(),
                                     CustomIdentifier(),
                                     DeviceCheckIdentifier(),
                                     DeviceModelIdentifier(),
                                     FirstTimeInstallationIdentifier(),
                                     VendorIdentifier()])
    }
    
    static func clearIdentifiers() {
        [AccessibilityIdentifier(),
         CellularIdentifier(),
         CustomIdentifier(),
         DeviceCheckIdentifier(),
         DeviceModelIdentifier(),
         FirstTimeInstallationIdentifier(),
         VendorIdentifier()].forEach { (element) in
            let id = (element as! IdentifierSource).type
            UserDefaults.standard.removeObject(forKey: id)
        }
    }
}
