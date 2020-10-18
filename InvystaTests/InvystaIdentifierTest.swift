//
//  InvystaIdentifierTest.swift
//  InvystaTests
//
//  Created by Cyril Garcia on 10/12/20.
//

import XCTest

final class MockVendorIdentifier: IdentifierSource {
    var type: String = "MockType"
    
    func identifier() -> String? {
        return "MockVendorIdentifier"
    }
}

class InvystaIdentifierTest: XCTestCase {

    var identifierManager: IdentifierManager!
    
    func testIdentifierParsing() {
        let browserData = BrowserData(email: "MockEmail",
                                      gateKeeper: "MockGateKeeper",
                                      fileName: "MockFileName",
                                      action: "MockAction",
                                      oneTimeCode: "MockOneTimeCode")
        identifierManager = IdentifierManager(browserData, [MockVendorIdentifier()])
        XCTAssertTrue(identifierManager!.identifiers["MockType"] == "MockVendorIdentifier")
        
    }
    
}
