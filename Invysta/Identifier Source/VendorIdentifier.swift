//
//  VendorIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import InvystaCore

struct VendorIdentifier: IdentifierSource {
    var type: String = IdentifierType.VendorID.rawValue
    
    func identifier() -> String? {
        return UIDevice().identifierForVendor?.uuidString
    }
}
