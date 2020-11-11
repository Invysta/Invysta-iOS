//
//  RequestURL.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import Foundation

enum CallType: String {
    case register = "/register"
    case login = "/login"
    case none = ""
}

enum RequestType: String {
    case post = "POST"
    case get = "GET"
}

struct RequestURL: Equatable {
    let baseURL = "https://invystasafe.com"
    var requestType: RequestType
    
    var body: String?
    var xacid: String?
    var userIDAndPassword: String?
    var action: String?
    
    var callType: CallType {
        switch action {
        case "log":
            return .login
        case "reg":
            return .register
        default:
            return .none
        }
    }
    
    var url: URLRequest {
        var urlstr: String
        
        if FeatureFlagBrowserData().trigger {
            urlstr = "https://hookb.in/9X1P3EEDVdS600eMoOmw"
        } else {
            urlstr = baseURL + callType.rawValue
        }
        
        var request = URLRequest(url: URL(string: urlstr)!)
        request.httpMethod = requestType.rawValue
        
        if let xacid = self.xacid {
            request.addValue(xacid, forHTTPHeaderField: "X-ACID")
            
            print("Set X_ACID",xacid)
        }
        
        if let userIDAndPassword = self.userIDAndPassword {
            request.addValue(userIDAndPassword, forHTTPHeaderField: "Authorization")
            
            print("Set basic",userIDAndPassword)
        }
        
        if let body = self.body {
            request.httpBody = body.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            print("Set body",body)
        }
        
        return request
    }
    
}
