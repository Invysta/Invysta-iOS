//
//  AuthenticationControllerTest.swift
//  InvystaTests
//
//  Created by Cyril Garcia on 4/30/21.
//

import XCTest
@testable import Invysta
@testable import InvystaCore

class AuthenticationControllerTest: XCTestCase {
    
    final class MockInvystaProcess: InvystaProcess<AuthenticationModel> {
        
        private let res: InvystaResult
      
        init(_ res: InvystaResult) {
            self.res = res
            
            let authObj = AuthenticationModel(uid: "uid", nonce: "nonce", caid: "caid", identifiers: [])
            super.init(authObj, "url")
        }
        
        override func start(_ completion: @escaping (InvystaResult) -> Void) {
            completion(res)
        }
    }

    func testAuthentication() {
        
        var process = MockInvystaProcess(.failure("Mock Error", -1))
        
        XCTAssertEqual(process.invystaURL.object.uid, "uid")
        XCTAssertEqual(process.invystaURL.object.nonce, "nonce")
        XCTAssertEqual(process.invystaURL.object.caid, "caid")
        XCTAssertEqual(process.invystaURL.url, "url/reg-login")
        XCTAssertEqual(process.invystaURL.object.identifiers, [])
        
        let queue = DispatchQueue(label: "authentication")
        
        var auth = AuthenticationViewController(process, queue)
        auth.beginAuthenticationProcess()
        XCTAssertEqual(auth.titleLabel.text!, "Mock Error")
        
        process = MockInvystaProcess(.success(201))
        auth = AuthenticationViewController(process, queue)
        auth.beginAuthenticationProcess()
        XCTAssertEqual(auth.titleLabel.text!, "Login Successful!")
    }
    
}
