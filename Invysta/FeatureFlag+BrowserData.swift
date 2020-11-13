//
//  FeatureFlag+BrowserData.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/22/20.
//

import Foundation

final class FeatureFlagBrowserData: FeatureFlagType {
    
    var trigger: Bool = false
    
    func check() -> Any? {
        if trigger {
            return BrowserData(action: "reg",
                               encData: "encData",
                               magic: "magicVal")
        }
        return nil
    }
}
