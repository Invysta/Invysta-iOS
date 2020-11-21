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

struct RequestURL {
 
    let baseURL = "https://invystasafe.com"
    var requestType: RequestType
    var browserData: BrowserData
    
    var body: String?
    var xacid: String?

    var url: URLRequest {
        var urlstr: String = ""
        print("")
        print("Creating URLRequest")
        if browserData.callType == .register && requestType == .get {
            urlstr = baseURL
        } else if browserData.callType == .register && requestType == .post {
            urlstr = baseURL + browserData.callType.rawValue
        } else if browserData.callType == .login && requestType == .get {
            urlstr = baseURL + browserData.callType.rawValue
        } else if browserData.callType == .login && requestType == .post {
            urlstr = baseURL + "/index.html"
        } else {
            urlstr = baseURL
        }
        
        if let url = FeatureFlagBrowserData().hookbin() {
            urlstr = url
        }
        
        print("URL: ",urlstr, requestType.rawValue)
        
        var request = URLRequest(url: URL(string: urlstr)!)
        request.httpMethod = requestType.rawValue
        print("---")
        
        request.setValue("Basic " + browserData.encData, forHTTPHeaderField: "Authorization")
        print("Setting Authorization",browserData.encData)
        
        if let xacid = self.xacid {
            request.setValue(xacid, forHTTPHeaderField: "X-ACID")
            print("Setting X_ACID",xacid)
        }
        
        if let body = self.body {
            request.httpBody = body.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            print("Setting Body",body)
        }
        print("")
        return request
    }
    
}
