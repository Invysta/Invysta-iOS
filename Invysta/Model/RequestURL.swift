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
        var request = URLRequest(url: URL(string: baseURL + callType.rawValue)!)
        request.httpMethod = requestType.rawValue
        
        if let xacid = self.xacid {
            request.addValue(xacid, forHTTPHeaderField: "X-ACID")
            print("Set X_ACID",xacid)
        }
        
        if let userIDAndPassword = self.userIDAndPassword {
            request.addValue("Basic " + userIDAndPassword, forHTTPHeaderField: "Authorization")
            print("Set basic",userIDAndPassword)
        }
        
        if let body = self.body {
            request.httpBody = Data(base64Encoded: body)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            print("Set body",body)
        }
        
        return request
    }
    
}
