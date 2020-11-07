//
//  IdentifierManager.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit

protocol IdentifierSource {
    var type: String { get set }
    func identifier() -> String?
}

final class IdentifierManager {
    
    private(set) var identifiers = [String: String]()
    
    var magic: String?
    
    private var browserData: BrowserData
    
    init(_ browserData: BrowserData, _ sources: [IdentifierSource]) {
        self.browserData = browserData
        for source in sources where source.identifier() != nil {
            identifiers[source.type] = source.identifier()
        }
    }
  
    func compileSources() -> String {
        var param: String
        param = "caid=" + createClientAgentId()
        
        if let magic = self.magic {
            param += "&magic=" + magic
        }
        
        return param
    }
    
    private func createClientAgentId() -> String {
        var caid = ""
        
        if let vendorId = identifiers["VendorID"] {
            caid += vendorId
        }
        
        if let advertiserId = identifiers["AdvertiserID"] {
            caid += advertiserId
        }
        
        return caid
    }
    
}
