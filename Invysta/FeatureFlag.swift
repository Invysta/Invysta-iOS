//
//  FeatureFlag.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/22/20.
//

import Foundation

protocol FeatureFlagType {
    var trigger: Bool { get }
    func check() -> Any?
}

final class FeatureFlag {
    static var showDebuggingTextField: Bool = true
}
