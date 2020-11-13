//
//  InvystaIdentifierTests.swift
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

struct MockVendorSource: IdentifierSource {
    var type: String = "VendorID"
    
    func identifier() -> String? {
        return "MockValue"
    }
    
}

struct MockAdvertisementSource: IdentifierSource {
    var type: String = "AdvertiserID"
    
    func identifier() -> String? {
        return nil
    }
    
}

class InvystaIdentifierTests: XCTestCase {

    var identifierManager: IdentifierManager!
    
    let browserData = BrowserData(action: "reg", encData: "encdata", magic: "magic")
    
    func testIdentifierParsing() {
        identifierManager = IdentifierManager(browserData, [MockVendorIdentifier()])
        XCTAssertTrue(identifierManager!.identifiers["MockType"] == "MockVendorIdentifier")
    }
    
    func testIdentifierSources() {
        identifierManager = IdentifierManager(browserData, [MockVendorSource(), MockAdvertisementSource()])
        XCTAssertEqual(identifierManager.identifiers.count, 1)
        XCTAssertEqual(identifierManager.compileSources(), "caid=MockValue&magic=MockFileName&otc=MockOneTimeCode")
    }
    
}
