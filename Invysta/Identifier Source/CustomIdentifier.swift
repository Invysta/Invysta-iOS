//
//  CustomIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import Foundation
import InvystaCore

struct CustomIdentifier: IdentifierSource {
    
    var type: String = IdentifierType.CustomID.rawValue
    
    func identifier() -> String? {
        if let uuid = KeychainWrapper.standard.string(forKey: type) {
            return uuid
        } else {
            let uuid = UUID().uuidString
            KeychainWrapper.standard.set(uuid, forKey: type)
            return uuid
        }
    }
}
