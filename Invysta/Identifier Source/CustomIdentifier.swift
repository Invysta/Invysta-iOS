//
//  CustomIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import Foundation

struct CustomIdentifier: IdentifierSource {
    func identifier() -> String? {
        let uuid = UUID().uuidString
        
        return uuid
    }
    
    func generateNewUUID() -> String {
        return UUID().uuidString
    }
    
    func storeUUID() {
        
    }
    
    func retrieveUUID() {
        
    }
}
