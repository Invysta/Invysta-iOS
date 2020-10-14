//
//  AdvertiserIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import AdSupport

struct AdvertiserIdentifier: IdentifierSource {
    func identifier() -> String? {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
}
