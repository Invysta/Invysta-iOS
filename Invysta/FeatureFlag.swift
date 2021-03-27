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
    static var showDebuggingTextField: Bool = false
    static var mockSuccessLabel: Bool = false
}

final class InvystaService {
    static func reclaimedMemory<T>(_ cls: T) {
        Swift.print("")
        Swift.print("##########")
        Swift.print("Reclaimed memory")
        Swift.print("CLASS: \(type(of: cls))")
        Swift.print("##########")
        Swift.print("")
    }
    
    enum EmojiType: String {
        case check = "✅"
        case error = "❌"
        case warning = "⚠️"
        case alert = "🚨"
    }
    
    static func log(_ emoji: EmojiType, _ message: String) {
        Swift.print("")
        Swift.print("########################################")
        Swift.print(emoji.rawValue, message)
        Swift.print("########################################")
        Swift.print("")
    }
    
    static func log(_ emoji: EmojiType, _ message: Any) {
        Swift.print("")
        Swift.print("########################################")
        Swift.print(emoji.rawValue, message)
        Swift.print("########################################")
        Swift.print("")
    }
    
}
