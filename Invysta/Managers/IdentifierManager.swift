//
//  IdentifierManager.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import CommonCrypto

protocol IdentifierSource {
    var type: IdentifierType { get set }
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
    
    private var sources = [IdentifierSource]()
        
    private(set) var compiledSources = [String]()
    
    init(_ sources: [IdentifierSource]? = nil) {
        
        self.sources = sources ?? [AccessibilityIdentifier(),
                                   CellularIdentifier(),
                                   CustomIdentifier(),
                                   DeviceCheckIdentifier(),
                                   DeviceModelIdentifier(),
                                   FirstTimeInstallationIdentifier(),
                                   VendorIdentifier()]
        
        super.init()
        compiledSources = self.sources.compactMap({ $0.identifier() })
    }
    
    func createClientAgentId() -> String {
        var caid = ""
        
        if let firstIdentifier = sources.first?.identifier() {
            caid += firstIdentifier
        }
        
        if let lastIdentifier = sources.last?.identifier() {
            caid += lastIdentifier
        }
        
        return SHA256(data: caid.data(using: .ascii))
    }
    
}
