//
//  IdentifierManager.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit

protocol IdentifierSource {
    func identifier() -> String?
}

final class IdentifierManager {
    
    var identifiers = [String]()
    
    init(_ sources: [IdentifierSource]) {
        for source in sources where source.identifier() != nil {
            identifiers.append(source.identifier()!)
        }
    }    
}
