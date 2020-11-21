//
//  InvystaNetworkTests.swift
//  InvystaTests
//
//  Created by Cyril Garcia on 10/12/20.
//

import XCTest

class InvystaNetworkTests: XCTestCase {

    func testPOSTNetworkCall() {
        
        let mockPost = MockPOSTSessionDataTask()
        let mockGet = MockGETSessionDataTask()
        
        let mockSession = MockURLSession(mockGet,mockPost)
        let networkManager = NetworkManager(mockSession)
        
        let browserData = BrowserData(action: "log", encData: "some-encrypted-data", magic: "some-magic-number")
        let req = RequestURL(requestType: .post, browserData: browserData)
                
        networkManager.call(req) { (data, response, error) in
            XCTAssertEqual(String(data: data!, encoding: .utf8), "SomeData")
            XCTAssertEqual(response!.url!, URL(string: "https://someurl.com")!)
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

final class MockPOSTSessionDataTask: URLSessionDataTaskProtocol {
    var didResume: Bool = false
    var url: RequestURL!
    func resume() {
        didResume = true
    }
    
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void) {
        completion(nil,nil,nil)
    }
}

final class MockGETSessionDataTask: URLSessionDataTaskProtocol {
    var didResume: Bool = false
    var url: RequestURL!
    
    func resume() {
        didResume = true
    }
    
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void) {
        let data = "SomeData".data(using: .utf8)
        let response = HTTPURLResponse(url: url.url.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: ["X-ACID":"X-ACID-MOCK"])
        completion(data,response,nil)
    }
}

final class MockURLSession: URLSessionProtocol {
    
    private(set) var lastRequestURL: RequestURL?
    
    var mockGet: MockGETSessionDataTask
    var mockPost: MockPOSTSessionDataTask
    
    init(_ mockGet: MockGETSessionDataTask,_ mockPost: MockPOSTSessionDataTask) {
        self.mockGet = mockGet
        self.mockPost = mockPost
    }
    
    func dataTaskWithUrl(_ url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {

        if url.requestType == .get {
            
            lastRequestURL = url
            mockGet.url = url
            mockGet.data(completion)
            return mockGet
        } else {
            var reqUrl = url
            reqUrl.body = url.body! + "🙏🏻"
            lastRequestURL = reqUrl
            mockPost.url = reqUrl
            mockPost.data(completion)
            return mockPost
        }
        
    }
    
    
}
