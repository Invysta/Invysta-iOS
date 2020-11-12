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
    case none = "/"
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
        var urlstr: String = ""
        
//        if FeatureFlagBrowserData().trigger {
//            urlstr = "https://hookb.in/G9mdgMQdZYSWGGeQqxRY"
//        } else {
//            urlstr = baseURL + callType.rawValue
//        }
        
        if callType == .register && requestType == .get {
            urlstr = baseURL
        } else if callType == .register && requestType == .post {
            urlstr = baseURL + "/register"
        }
        
        if callType == .login && requestType == .get {
            urlstr = "https://invystasafe.com/login/"
        } else if callType == .login && requestType == .post {
            urlstr = "https://invystasafe.com/login/"
        }
        
        if FeatureFlagBrowserData().trigger {
            urlstr = "https://hookb.in/G9mdgMQdZYSWGGeQqxRY"
        }
        
        print(urlstr)
        
        var request = URLRequest(url: URL(string: urlstr)!)
        request.httpMethod = requestType.rawValue
        print("---")
        if let xacid = self.xacid {
            request.addValue(xacid, forHTTPHeaderField: "X-ACID")
            print("Seting X_ACID",xacid)
        }
        
        if let userIDAndPassword = self.userIDAndPassword {
            request.addValue("Basic " + userIDAndPassword, forHTTPHeaderField: "Authorization")
            print("Seting Authorization",userIDAndPassword)
        }

        if let body = self.body {
            request.httpBody = body.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            print("Seting Body",body)
        }
        
        return request
    }
    
}
