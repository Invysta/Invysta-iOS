//
//  RequestURL.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import Foundation

struct RequestURL {
    let baseURL = "https://bycyril.com"
    
    var url: URL {
        return URL(string: baseURL)!
    }
}
