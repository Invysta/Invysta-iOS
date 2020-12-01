//
//  NetworkManager.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit

protocol URLSessionProtocol {
    func dataTask(with url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
      -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    var url: RequestURL? { get set }
    func resume()
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void)
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    var url: RequestURL? {
        get {
            return nil
        }
        set {}
    }
    
    func data(_ completion: (Data?, URLResponse?, Error?) -> Void) {}
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
      -> URLSessionDataTaskProtocol {
        return dataTask(with: url.url, completionHandler: completion)
    }
}

final class NetworkManager {
    
    private var session: URLSessionProtocol?
    
    init(_ session: URLSessionProtocol?) {
        self.session = session
    }
    
    init() {
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        config.urlCredentialStorage = nil
        config.httpCookieStorage = .none
        config.httpCookieAcceptPolicy = .never
        session = URLSession(configuration: config)
    }
    
    public func call(_ url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session?.dataTask(with: url, completion: completion).resume()
    }
 
}
