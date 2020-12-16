//
//  FeatureFlag+BrowserData.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/22/20.
//

import Foundation

final class FeatureFlagBrowserData: FeatureFlagType {
    
    var trigger: Bool = false
    
    func hookbin() -> String? {
        return trigger ? "https://hookb.in/3OJrRD9wV0fEwwjBWa7y" : nil
    }
    
    func check() -> Any? {
        if trigger {
            return BrowserData(action: "log",
                               encData: "encData",
                               magic: "magicVal", url: URL(string: "https://someurl.com")!)
        }
        return nil
    }
}
