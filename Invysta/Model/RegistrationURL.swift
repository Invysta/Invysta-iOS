//
//  RequestURL.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import Foundation

protocol InvystaObject: Codable {
    associatedtype String
    var caid: String { get set }
    var identifiers: [String] { get set }
}

struct RegistrationObject: InvystaObject {
    var email: String
    var password: String
    var caid: String
    var otc: String
    var identifiers: [String]
}

struct AuthenticationObject: InvystaObject {
    var uid: String
    var nonce: String
    var caid: String
    var identifiers: [String]
}

enum URLType: String {
    case register = "http://192.168.1.207:3003/reg-device"
    case login = "http://192.168.1.207:3003/reg-login"
}

struct InvystaURL<T: InvystaObject> {
    
    var object: T
    
    var url: URLRequest {
        var urlstr: String
        
        if let url = FeatureFlagBrowserData().hookbin() {
            urlstr = url
        } else {
            if object is AuthenticationObject {
                urlstr = URLType.login.rawValue
            } else if object is RegistrationObject {
                urlstr = URLType.register.rawValue
            } else {
                urlstr = ""
            }
        }
        
        print("URL",urlstr)
        print("OBJ",object.caid)
        var request = URLRequest(url: URL(string: urlstr)!)
        
        do {
            let encoder = JSONEncoder()
            let encodedObject = try encoder.encode(object.self)
            request.httpBody = encodedObject
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            print(error.localizedDescription)
        }
        
        return request   
    }
}
