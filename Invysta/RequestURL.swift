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

struct RequestURL: Equatable {
    let baseURL = "https://invystasafe.com"
    var type: CallType
    var params: [String: String]?
    
    var url: URL {
        return URL(string: baseURL + type.rawValue)!
    }
    
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            guard let params = params else { return request }
            let data = try JSONSerialization.data(withJSONObject: params, options: .init())
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "content-type")
        } catch {
            print(error.localizedDescription)
        }
        
        return request
    }
}
