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
    
    var oneTimeCode: String?
    
    init(_ sources: [IdentifierSource]) {
        for source in sources where source.identifier() != nil {
            identifiers[source.type] = source.identifier()
        }
    }
    
    //    if (ActionRequest.equals("login")) {
    //                System.out.println("GETorPOST = get and register");
    //                values = "caid=" + caid +"&magic="+ magic;
    //                values = values + "&id1=" + AndroidID + "&id2=" + DeviceBrand;
    //                values = values + "&id3=" + DeviceManufacturer + "&id4=" + firstInstallTime;
    //                values = values + "&id5=" + DeviceModel + "&id6=" + DeviceBoard;
    //                values = values + "&id7=" + DeviceBootloader;
    //                System.out.println("Values " + values);
    //            } else if (ActionRequest.equals("register")) {
    //                System.out.println("GETorPOST = post");
    //                values = "caid=" + caid +"&magic="+ magic + "&otc="+ otc;
    //                values = values + "&id1=" + AndroidID + "&id2=" + DeviceBrand;
    //                values = values + "&id3=" + DeviceManufacturer + "&id4=" + firstInstallTime;
    //                values = values + "&id5=" + DeviceModel + "&id6=" + DeviceBoard;
    //                values = values + "&id7=" + DeviceBootloader;
    //                System.out.println("Values " + values);
    //            }
    
    func compileSources() -> String {
        var param: String
        
        if let oneTimeCode = self.oneTimeCode {
            param = "caid=" + createClientAgentId() + "&magic=" + "&otc=" + oneTimeCode
        } else {
            param = "caid"
        }
        
        return param
    }
    
    func createClientAgentId() -> String {
        var caid = ""
        
        if let vendorId = identifiers["VendorID"], let advertiserId = identifiers["AdvertiserID"] {
            caid = vendorId + advertiserId
        }
        return caid
    }
    
}
