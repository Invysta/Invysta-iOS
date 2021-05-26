//
//  BaseInvystaController.swift
//  Invysta
//
//  Created by Cyril Garcia on 5/25/21.
//

import UIKit
import LocalAuthentication
import InvystaCore

protocol LocalAuthenticationManagerDelegate: AnyObject {
    func localAuthenticationDidFail(_ error: Error?)
}

class LocalAuthenticationManager {
    
    private var error: NSError?
    weak var delegate: LocalAuthenticationManagerDelegate?
    
    private let laContext: LAContext = LAContext()
    private var queue: DispatchQueue
    
    init(_ queue: DispatchQueue = DispatchQueue.main) {
        self.queue = queue
    }
  
    func beginLocalAuthentication(_ fun: @escaping () -> Void) {
        guard IVUserDefaults.getBool(.DeviceSecurity) else {
            fun()
            return
        }
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            deviceAuthentication(with: .deviceOwnerAuthenticationWithBiometrics, fun: fun)
        } else {
            deviceAuthentication(with: .deviceOwnerAuthentication, fun: fun)
        }
    }
    
    func deviceAuthentication(with policy: LAPolicy, fun: @escaping () -> Void) {
        laContext.evaluatePolicy(policy, localizedReason: "Authenticate to begin the Invysta Authentication Process") { [weak self] (success, error) in
            self?.queue.async { [weak self] in
                if success {
                    fun()
                } else {
                    self?.delegate?.localAuthenticationDidFail(error)
                }
            }
        }
    }
    
}
