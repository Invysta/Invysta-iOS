//
//  InvystaObjects.swift
//  Invysta
//
//  Created by Cyril Garcia on 3/19/21.
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
