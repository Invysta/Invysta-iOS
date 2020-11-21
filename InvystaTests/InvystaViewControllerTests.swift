//
//  InvystaViewControllerTests.swift
//  InvystaTests
//
//  Created by Cyril Garcia on 11/16/20.
//

import XCTest


class InvystaViewControllerTests: XCTestCase {

    var vc: ViewController!
    var browserData: BrowserData!
    var networkManager: NetworkManager!
    var identifierManager: IdentifierManager!
    var mockSession: MockURLSession!
    
    var mockPost = MockPOSTSessionDataTask()
    var mockGet = MockGETSessionDataTask()
    
    var sources = ""
    
    override func setUp() {
        super.setUp()
        
        mockSession = MockURLSession(mockGet, mockPost)
        
        browserData = BrowserData(action: "log", encData: "some-enc-data", magic: "some-magic-number")
        networkManager = NetworkManager(mockSession)
        identifierManager = IdentifierManager(browserData, [
            MockIdentifier(type: "Demo1"),
            MockIdentifier(type: "Demo2"),
            MockIdentifier(type: "Demo3"),
            MockIdentifier(type: "Demo4"),
            MockIdentifier(type: "Demo5"),
            MockIdentifier(type: "Demo6"),
            MockIdentifier(type: "Demo7"),
            MockIdentifier(type: "Demo8"),
            MockIdentifier(type: "Demo9"),
            MockIdentifier(type: "Demo10"),
        ])
        
        sources = identifierManager.compiledSources!
        vc = ViewController(browserData, identifierManager, networkManager)
    }
    
    func testXACID() {
        vc.requestXACIDKey(browserData)
        XCTAssertEqual(mockSession.lastRequestURL?.browserData.action, "log")
        XCTAssertEqual(mockSession.lastRequestURL!.xacid, "X-ACID-MOCK")
    }
    
    func testAuth() {
        
        vc.authenticate(with: "X-ACID-MOCK", browserData)
        
        XCTAssertEqual(mockSession.lastRequestURL!.body!, identifierManager.compiledSources! + "🙏🏻")
    }
}
