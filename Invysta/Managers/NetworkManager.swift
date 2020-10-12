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
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

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

    public func post(_ url: RequestURL) {
        let task = session?.dataTaskWithUrl(url) { [weak self] (data, response, error) in
            self?.delegate?.networkResponse(data, response, error)
        }
        task?.resume()
    }
    
}
