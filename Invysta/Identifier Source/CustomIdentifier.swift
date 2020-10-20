//
//  CustomIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import Foundation
import SwiftKeychainWrapper

struct CustomIdentifier: IdentifierSource {
    
    var type: String = "CustomID"
    
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
