//
//  AdvertiserIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit

final class AdvertiserIdentifier: IdentifierSource {
    func identifier() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
}
