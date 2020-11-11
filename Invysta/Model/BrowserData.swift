//
//  BrowserData.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/16/20.
//

import Foundation

struct BrowserData {
    var action: String?
    var oneTimeCode: String?
    var encData: String?
    var magic: String?
    
    var see: String {
        return """
            action: \(action ?? "action na")
            oneTimeCode: \(oneTimeCode ?? "oneTimeCode na")
            encData: \(encData ?? "encData na")
            magic: \(magic ?? "magic na")
            """
    }
}
