//
//  CellularIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/19/20.
//

import UIKit
import CoreTelephony
import Invysta_Framework

final class CellularIdentifier: IdentifierSource {
    var type: String = IdentifierType.Cellular.rawValue
    
    func captureCellularInfo() -> String {
        var id: String = ""
        
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
            return UUID().uuidString
        }
        
        return SHA256(data: id.data(using: .utf8))
    }
    
    func identifier() -> String? {
        if let id = UserDefaults.standard.string(forKey: type) {
            return id
        } else {
            let id = captureCellularInfo()
            UserDefaults.standard.setValue(id, forKey: type)
            return id
        }
    }
    
}
