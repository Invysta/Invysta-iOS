//
//  IdentifierManager.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import CommonCrypto

protocol IdentifierSource {
    var type: String { get set }
    func identifier() -> String?
}

class Identifier {
    func SHA256(data: Data?) -> String {
        guard let data = data else { return "SHA-err" }
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        
        return Data(hash).map { String(format: "%02hhx", $0) }.joined()
    }
}

final class IdentifierManager: Identifier {
    
    private(set) var identifiers = [String: String]()
    private var orderedIdentifier = [String]()
    
    private var browserData: BrowserData
    
    init(_ browserData: BrowserData, _ sources: [IdentifierSource]) {
        self.browserData = browserData
        for source in sources where source.identifier() != nil {
            identifiers[source.type] = source.identifier()
            orderedIdentifier.append(source.identifier()!)
        }
    }
  
    func compileSources() -> String {
        var param: String
        param = "caid=" + createClientAgentId()
        param += "&magic=" + browserData.magic
        
        if let otc = browserData.oneTimeCode {
            param += "&otc=" + otc
        }
        
        for (i,identifier) in orderedIdentifier.enumerated() {
            param += "&id\(i + 1)=" + identifier
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
                
        return SHA256(data: caid.data(using: .ascii))
    }
 
}
