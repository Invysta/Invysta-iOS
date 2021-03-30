//
//  DeviceModelIdentifier.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/6/20.
//

import UIKit
import InvystaCore

struct DeviceModelIdentifier: IdentifierSource {
    var type: String = IdentifierType.DeviceModel.rawValue
    
    func identifier() -> String? {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return SHA256(data: identifier.data(using: .utf8))
    }
}
