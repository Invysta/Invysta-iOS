//
//  InvystaNetworkTests.swift
//  InvystaTests
//
//  Created by Cyril Garcia on 10/12/20.
//

import XCTest

class InvystaNetworkTests: XCTestCase {

    func testGETNetworkCall() {
        
        let mock = MockSessionDataTask()
        
        let mockSession = MockURLSession(mock)
        let networkManager = NetworkManager(mockSession)
        
        let browserData = BrowserData(action: "log", encData: "some-encrypted-data", magic: "some-magic-number")
        let req = RequestURL(requestType: .get, browserData: browserData)
                
        networkManager.call(req) { (data, response, error) in
            XCTAssertEqual(String(data: data!, encoding: .utf8), "SomeData")
            XCTAssertEqual(response!.url!, URL(string: "https://invystasafe.com/login")!)
            XCTAssertNil(error)
        }
    }
    
    func testPOSTNetworkCall() {
        let mock = MockSessionDataTask()
        
        let mockSession = MockURLSession(mock)
        let networkManager = NetworkManager(mockSession)
        
        let browserData = BrowserData(action: "reg", encData: "some-encrypted-data", magic: "some-magic-number")
        let req = RequestURL(requestType: .post, browserData: browserData)
                
        networkManager.call(req) { (data, response, error) in
            XCTAssertEqual(String(data: data!, encoding: .utf8), "SomeData")
            XCTAssertEqual(response!.url!, URL(string: "https://invystasafe.com/register")!)
            XCTAssertNil(error)
        }
    }
}

struct MockIdentifier: IdentifierSource {
    var type: String
    
    func identifier() -> String? {
        return type
    }
}

final class MockSessionDataTask: URLSessionDataTaskProtocol {
    var url: RequestURL?
    var didResume: Bool = false
    
    func resume() {
        didResume = true
    }
    
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void) {
        let data = "SomeData".data(using: .utf8)
        let response = HTTPURLResponse(url: url!.url.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: ["X-ACID":"X-ACID-MOCK"])
        completion(data,response,nil)
    }
}

final class MockURLSession: URLSessionProtocol {
    
    private(set) var lastRequestURL: RequestURL?
    
    var mock: URLSessionDataTaskProtocol
    
    init(_ mock: URLSessionDataTaskProtocol) {
        self.mock = mock
    }
    
    func dataTask(with url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastRequestURL = url
        mock.url = url
        mock.data(completion)
        return mock
    }
        
}
