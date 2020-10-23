//
//  FeatureFlag.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/22/20.
//

import Foundation

protocol FeatureFlagType {
    var trigger: Bool? { get set }
    func condition() -> Bool
}

final class FeatureFlag {
    
    var shared = FeatureFlag()
    
    static func testBrowserData() -> Bool {
        let featureFlagBrowserData = FeatureFlagBrowserData()
        featureFlagBrowserData.trigger = true
        return featureFlagBrowserData.condition()
    }
    
}
