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
    
    var identifiers = [String: String]()
    
    private var browserData: BrowserData
    
    init(_ browserData: BrowserData, _ sources: [IdentifierSource]) {
        self.browserData = browserData
        for source in sources where source.identifier() != nil {
            identifiers[source.type] = source.identifier()
        }
    }
  
    func compileSources() -> String {
        var param: String
        
        if let oneTimeCode = browserData.oneTimeCode {
            param = "caid=" + createClientAgentId() + "&magic=" + browserData.fileName + "&otc=" + oneTimeCode
        } else {
            param = "caid=" + createClientAgentId() + "&magic=" + browserData.fileName
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
