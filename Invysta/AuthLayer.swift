//
//  AuthLayer.swift
//  Invysta
//
//  Created by Cyril Garcia on 3/5/21.
//

import Foundation

final class AuthLayer {
    let networkManager: NetworkManager
    let authObject: AuthenticationObject
    
    init(_ authObject: AuthenticationObject,
         _ networkManager: NetworkManager = NetworkManager()) {
        self.authObject = authObject
        self.networkManager = networkManager
    }
    
    func auth() {
        let urlObj = InvystaURL(object: authObject)
        
        networkManager.call(urlObj) { (data, res, error) in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject] {
                print(jsonObj)
            }
            
            if let res = res as? HTTPURLResponse {
                print("status code",res.statusCode)
            }
        }
    }
}
