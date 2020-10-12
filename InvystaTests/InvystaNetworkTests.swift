//
//  InvystaNetworkTests.swift
//  InvystaTests
//
//  Created by Cyril Garcia on 10/12/20.
//

import XCTest

final class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?
    weak var delegate: NetworkManagerDelegate?
    
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?
    
    func dataTaskWithUrl(_ url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURL = url.url
        nextDataTask.data(completion)
        return nextDataTask
    }
    
}

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    func resume() {}
    
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void) {
        let data = Data(base64Encoded: "MockData")
        let urlResponse = URLResponse()
        completion(data, urlResponse, nil)
    }
}

class InvystaNetworkTests: XCTestCase, NetworkManagerDelegate {
   
    func testNetworkManager() {
        let mockSession = MockURLSession()
        let networkManager = NetworkManager(mockSession)
        networkManager.delegate = self
        
        let requestURL = RequestURL()
        networkManager.post(requestURL)
    }
    
    func networkResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        XCTAssertNotNil(data)
        XCTAssertNotNil(response)
        XCTAssertNil(error)
    }
    
}
