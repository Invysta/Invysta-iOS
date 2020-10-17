//
//  RequestURL.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import Foundation

enum CallType: String {
    case register = "/register/"
    case login = "/login/"
    case none = ""
}

enum RequestType: String {
    case post = "POST"
    case get = "GET"
}

struct RequestURL: Equatable {
    let baseURL = "https://invystasafe.com"
    var callType: CallType
    var requestType: RequestType
    
    var params: [String: String]?

    var identifiers: String?
    
    var url: URLRequest {
        var request = URLRequest(url: URL(string: baseURL + callType.rawValue)!)
        request.httpMethod = requestType.rawValue
        
        guard let identifiers = self.identifiers else { return request }
        
        request.httpBody = Data(base64Encoded: identifiers)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        return request
    }
    
}
