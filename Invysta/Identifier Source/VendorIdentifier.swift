//
//  VendorIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit

final class VendorIdentifier: IdentifierSource {
    func identifier() -> String? {
        return UIDevice().identifierForVendor?.uuidString
    }
}
