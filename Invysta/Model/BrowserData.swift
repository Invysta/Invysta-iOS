//
//  BrowserData.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/16/20.
//

import Foundation

struct BrowserData {
    var action: String
    var uid: String
    var nonce: String

    var see: String {
        return """
            action: \(action)
            uid: \(uid)
            nonce: \(nonce)
            """
    }
}
