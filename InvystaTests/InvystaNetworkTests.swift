//
//  InvystaNetworkTests.swift
//  InvystaTests
//
//  Created by Cyril Garcia on 10/12/20.
//

import XCTest

final class MockURLSession: URLSessionProtocol {
   
    var nextDataTask: URLSessionDataTaskProtocol
    private(set) var lastRequestURL: RequestURL?
    
    weak var delegate: NetworkManagerDelegate?

    init(_ task: URLSessionDataTaskProtocol) {
        nextDataTask = task
    }
    
    func dataTaskWithUrl(_ url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastRequestURL = url
        nextDataTask.data(completion)
        return nextDataTask
    }
 
}

final class MockPOSTURLSessionDataTask: URLSessionDataTaskProtocol {
    
    var didResume: Bool = false
    var params = [String: String]()
    
    func resume() {
        didResume = true
    }
    
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void) {
        completion(Data(base64Encoded: "MockData"), URLResponse(), nil)
    }
}

final class MockPOSTNetworkResponseDelegate: XCTestCase, NetworkManagerDelegate {
    func networkResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        XCTAssertNotNil(data)
        XCTAssertNotNil(response)
        XCTAssertNil(error)
    }
}

final class MockGETURLSessionDataTask: URLSessionDataTaskProtocol {
    
    var didResume: Bool = false
    
    func resume() {
        didResume = true
    }
    
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void) {
        completion(nil,nil,nil)
    }
}

final class MockGETNetworkResponseDelegate: XCTestCase, NetworkManagerDelegate {
    func networkResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        XCTAssertNil(data)
        XCTAssertNil(response)
        XCTAssertNil(error)
    }
}

class InvystaNetworkTests: XCTestCase {

    let postMockDelegate = MockPOSTNetworkResponseDelegate()
    let getMockDelegate = MockGETNetworkResponseDelegate()
    let browserData = BrowserData(action: "", oneTimeCode: "", encData: "", magic: "")
    func testGETNetworkCall() {
        
        let requestURL = RequestURL(requestType: .get, browserData: browserData)
        let mockSession = MockURLSession(MockGETURLSessionDataTask())
        
        let networkManager = NetworkManager(mockSession)
        networkManager.delegate = getMockDelegate
        networkManager.call(requestURL) { (data, response, error) in
            
        }
        
        XCTAssertNil(mockSession.lastRequestURL?.body)
        XCTAssertTrue(mockSession.nextDataTask.didResume)
//        XCTAssertTrue(mockSession.lastRequestURL?.browserData == requestURL.browserData)
    }
    
    func testPOSTNetworkCall() {
        let requestURL = RequestURL(requestType: .post, browserData: browserData)
        
        let mockSession = MockURLSession(MockPOSTURLSessionDataTask())
        
        let networkManager = NetworkManager(mockSession)
        networkManager.delegate = postMockDelegate
        networkManager.call(requestURL) { (data, res, error) in
            
        }
        
        XCTAssertNotNil(mockSession.lastRequestURL?.body)
        XCTAssertTrue(mockSession.lastRequestURL!.body == "mock-data")
        XCTAssertTrue(mockSession.nextDataTask.didResume)
//        XCTAssertTrue(mockSession.lastRequestURL == requestURL)
    }

    func networkResponse() {
        
    }
}
