//
//  InvystaNetworkTests.swift
//  InvystaTests
//
//  Created by Cyril Garcia on 10/12/20.
//

import XCTest

class InvystaNetworkTests: XCTestCase {
    
    final class MockNetworkManagerDataTask: URLSessionDataTaskProtocol {
                    
        var url: Any?
        var didResume = false
        
        func findUrl<T>(_ url: InvystaURL<T>) where T : InvystaObject {
            self.url = url
        }
        
        func resume() {
            didResume = true
        }
        
        func data(_ completion: (Data?, URLResponse?, Error?) -> Void) {
            completion("Network Call Success".data(using: .utf8), nil, nil)
        }
        
    }
    
    class MockURLSession: URLSessionProtocol {
        
        private var mock: URLSessionDataTaskProtocol
        
        init(_ mock: URLSessionDataTaskProtocol) {
            self.mock = mock
        }
        
        func dataTask<T>(with url: InvystaURL<T>, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol where T : InvystaObject {
            let obj = AuthenticationObject(uid: "", nonce: "", caid: "", identifiers: ["",""])
            let url = InvystaURL(object: obj)
            mock.findUrl(url)
            
            return mock
        }
        
    }
    
    func testNetworkCall() {
        let mockNetworkManagerDataTask = MockNetworkManagerDataTask()
        let mockURLSession = MockURLSession(mockNetworkManagerDataTask)
        let networkManager = NetworkManager(mockURLSession)
        
        let obj = AuthenticationObject(uid: "", nonce: "", caid: "", identifiers: ["",""])
        let url = InvystaURL(object: obj)
        
        XCTAssertFalse(mockNetworkManagerDataTask.didResume)
        
        networkManager.call(url) { (data, res, error) in
            print("here")
            XCTAssertEqual(String(data: data!, encoding: .utf8), "Network Call Successs")
            XCTAssertNil(res)
            XCTAssertNil(error)
        }
        
        XCTAssertTrue(mockNetworkManagerDataTask.didResume)
        
    }
}
