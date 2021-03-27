//
//  CellularIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/19/20.
//

import UIKit
import CoreTelephony

final class CellularIdentifier: Identifier, IdentifierSource {
    var type: IdentifierType = .Cellular
    
    func captureCellularInfo() -> String? {
        var id = ""
        
        let networkInfo = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            if let carriers = networkInfo.serviceSubscriberCellularProviders?.values {
                for val in carriers {
                    id += val.carrierName ?? "carrierName"
                    id += val.mobileCountryCode ?? "mobileCountryCode"
                    id += val.mobileNetworkCode ?? "mobileNetworkCode"
                }
            }
            
        } else {
            if let radioTech = networkInfo.currentRadioAccessTechnology {
                id += radioTech
            }
        }
        
        if id.isEmpty {
            return nil
        }
        
        return SHA256(data: id.data(using: .utf8))
    }
    
    func identifier() -> String? {
        if let id = UserDefaults.standard.string(forKey: type.rawValue) {
            return id
        } else {
            guard let id = captureCellularInfo() else { return nil }
            UserDefaults.standard.setValue(id, forKey: type.rawValue)
            return id
        }
    }
    
}
