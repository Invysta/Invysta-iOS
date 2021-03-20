//
//  InvystaError.swift
//  Invysta
//
//  Created by Cyril Garcia on 3/19/21.
//

import Foundation

struct InvystaError: Decodable {
    var error: String
    var errors: [InvystaErrorDetails]?
}

struct InvystaErrorDetails: Decodable {
    var location: String
    var msg: String
    var param: String
    var value: String
}
