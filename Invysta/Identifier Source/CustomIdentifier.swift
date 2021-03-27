//
//  CustomIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import Foundation

struct CustomIdentifier: IdentifierSource {
    
    var type: IdentifierType = .CustomID
    
    func identifier() -> String? {
        if let uuid = UserDefaults.standard.string(forKey: type.rawValue) {
            return uuid
        } else {
            let uuid = UUID().uuidString
            UserDefaults.standard.setValue(uuid, forKey: type.rawValue)
            return uuid
        }
    }
}
