//
//  NetworkManager.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit

protocol URLSessionProtocol {
    func dataTaskWithUrl(_ url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
      -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    var didResume: Bool { get set }
    func resume()
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void)
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
    func dataTaskWithUrl(_ url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url.url, completionHandler: completion)
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
    
    public func call(_ url: RequestURL) {
        let task = session?.dataTaskWithUrl(url, completion: { [weak self] (data, response, error) in
            self?.delegate?.networkResponse(data, response, error)
        })
        task?.resume()
    }
 
}
