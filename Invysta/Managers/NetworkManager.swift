//
//  NetworkManager.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit

protocol URLSessionProtocol {
    func dataTaskWithUrl(_ url: RequestURL,_ type: RequestType, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
      -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    var didResume: Bool { get set }
    func resume()
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void)
}

enum RequestType: String {
    case post = "POST"
    case get = "GET"
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    var didResume: Bool {
        get {
            return false
        }
        set {
            
        }
    }
    
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void) {}
}

extension URLSession: URLSessionProtocol {
    func dataTaskWithUrl(_ url: RequestURL, _ type: RequestType, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        switch type {
        case .get:
            return dataTask(with: url.url, completionHandler: completion)
        case .post:
            return dataTask(with: url.request, completionHandler: completion)
        }
    }

}

protocol NetworkManagerDelegate: AnyObject {
    func networkResponse(_ data: Data?,_ response: URLResponse?,_ error: Error?)
}

final class NetworkManager {
    
    var session: URLSessionProtocol?
    weak var delegate: NetworkManagerDelegate?
    
    init(_ session: URLSessionProtocol? = URLSession.shared) {
        self.session = session
    }
    
    public func call(_ url: RequestURL,_ type: RequestType) {
        let task = session?.dataTaskWithUrl(url, type, completion: { [weak self] (data, response, error) in
            self?.delegate?.networkResponse(data, response, error)
        })
        task?.resume()
    }
 
}
