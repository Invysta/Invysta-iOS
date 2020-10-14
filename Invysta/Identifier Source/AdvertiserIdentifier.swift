//
//  AdvertiserIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import AdSupport

final class AdvertiserIdentifier: IdentifierSource {
    func identifier() -> String? {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
}
