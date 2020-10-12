//
//  InvystaIdentifierTest.swift
//  InvystaTests
//
//  Created by Cyril Garcia on 10/12/20.
//

import XCTest

final class MockVendorIdentifier: IdentifierSource {
    func identifier() -> String? {
        return "MockVendorIdentifier"
    }
}

class InvystaIdentifierTest: XCTestCase {

    var identifierManager: IdentifierManager!
    
    func testIdentifierParsing() {
        identifierManager = IdentifierManager([MockVendorIdentifier()])
        XCTAssertTrue(identifierManager!.identifiers.first! == "MockVendorIdentifier")
        
    }
    
}
