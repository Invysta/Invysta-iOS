//
//  InvystaUITests.swift
//  InvystaUITests
//
//  Created by Cyril Garcia on 4/24/21.
//

import XCTest

class InvystaUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
    }
    
    func testOpenURL() {
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        // Launch safari
        safari.launch()
        // Ensure that safari is running in foreground before we continue
        _ = safari.wait(for: .runningForeground, timeout: 30)
        
        safari.buttons["URL"].tap()
        safari.typeText("https://invysta-technical.com")
        safari.typeText("\n")
 
        safari.buttons["Access Protected"].tap()
        safari.buttons["open app"].tap()
        safari.buttons["Open"].tap()

        _ = app.wait(for: .runningBackground, timeout: 2)
        
        let systemApp = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        systemApp.buttons["Return to Safari"].tap()
        
        safari.typeText("cyril@invysta.com")
        safari.buttons["Next"].tap()
        safari.typeText("123321")
        safari.typeText("\n")
        
        safari.buttons["Continue"].tap()
        
        XCTAssertTrue(safari.staticTexts["Welcome to InvystaSafe.com"].exists)
    }
    
    func testExample() {
        app.tabBars.buttons["Settings"].tap()
        app.tableRows.buttons["Register Device"].tap()
    }

}
