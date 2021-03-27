//
//  VendorIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit

struct VendorIdentifier: IdentifierSource {
    var type: IdentifierType = .VendorID
    
    func identifier() -> String? {
        return UIDevice().identifierForVendor?.uuidString
    }
}
