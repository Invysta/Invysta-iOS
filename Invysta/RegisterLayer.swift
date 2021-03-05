//
//  RegisterLayer.swift
//  Invysta
//
//  Created by Cyril Garcia on 2/26/21.
//

import Foundation

final class RegisterLayer {
    
    let networkManager: NetworkManager
    let regObject: RegistrationObject
    
    init(_ regObject: RegistrationObject,
         _ networkManager: NetworkManager = NetworkManager()) {
        self.regObject = regObject
        self.networkManager = networkManager
    }
    
    func register() {
        let urlObj = InvystaURL(object: regObject, baseURL: .register)
        
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
