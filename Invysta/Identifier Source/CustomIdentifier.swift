//
//  CustomIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import Foundation
import Invysta_Framework

struct CustomIdentifier: IdentifierSource {
    
    var type: String = IdentifierType.CustomID.rawValue
    
    func identifier() -> String? {
        if let uuid = UserDefaults.standard.string(forKey: type) {
            return uuid
        } else {
            let uuid = UUID().uuidString
            UserDefaults.standard.setValue(uuid, forKey: type)
            return uuid
        }
    }
}
