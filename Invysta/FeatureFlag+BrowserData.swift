//
//  FeatureFlag+BrowserData.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/22/20.
//

import Foundation

final class FeatureFlagBrowserData: FeatureFlagType {
    var trigger: Bool?
    func condition() -> Bool {
        return trigger ?? false
    }
}
