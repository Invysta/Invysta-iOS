//
//  Endpoint.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/13/20.
//

import Foundation

enum Endpoint {
    case user
    
    var url: URL {
        let baseUrl = "https://bycyril.com/privacy-policy"
        
        return URL(string: baseUrl)!
    }
}
