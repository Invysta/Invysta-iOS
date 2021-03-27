//
//  RequestURL.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import Foundation

struct InvystaURL<T: InvystaObject> {
    
    var object: T
    
    var url: URLRequest {
        var urlstr: String = ""
        
        if let url = FeatureFlagBrowserData().hookbin() {
            urlstr = url
        } else {
            if object is AuthenticationObject {
                urlstr = IVUserDefaults.getString(.providerKey)! + "/reg-login"
            } else if object is RegistrationObject {
                let obj = object as! RegistrationObject
                urlstr = obj.provider + "/reg-device"
            }
        }
        
        InvystaService.log(.warning, urlstr)
        InvystaService.log(.warning, object.caid)
        
        var request = URLRequest(url: URL(string: urlstr)!)
        
        do {
            let encoder = JSONEncoder()
            let encodedObject = try encoder.encode(object.self)
            request.httpBody = encodedObject
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            InvystaService.log(.error, error.localizedDescription)
        }
        
        return request   
    }
}
