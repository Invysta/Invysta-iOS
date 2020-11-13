//
//  ViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import LocalAuthentication

class ViewController: BaseViewController {

    private var identifierManager: IdentifierManager?
    private var networkManager: NetworkManager?
    
    private var error: NSError?
    private let context = LAContext()

    init(_ browserData: BrowserData) {
        super.init(nibName: nil, bundle: nil)
        networkManager = NetworkManager()
        identifierManager = IdentifierManager(browserData, [
                                                VendorIdentifier(),
                                                AdvertiserIdentifier(),
                                                CustomIdentifier(),
                                                DeviceModelIdentifier(),
                                                DeviceCheckIdentifier(),
                                                AccessibilityIdentifier()])
        self.browserData = browserData
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        beginInvystaProcess(with: browserData)
        
        if FeatureFlag.showDebuggingTextField {
            let text = """
                            action: \(browserData?.action  ?? "na")\n
                            encData: \(browserData?.encData ?? "na")\n
                            magic: \(browserData?.magic ?? "na")\n
                            oneTimeCode: \(browserData?.oneTimeCode ?? "na")
                    """
            createDebuggingField(text)
        }
    }
    
    func beginInvystaProcess(with browserData: BrowserData?) {
        guard let browserData = self.browserData else { return }
        
        if FeatureFlagBrowserData().trigger {
            authenticate(with: "123321")
            return
        }
        
        if UserDefaults.standard.bool(forKey: "DeviceSecurity") {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Begin Invysta Authentication") { [weak self] (success, error) in
                DispatchQueue.main.async {
                    self?.displayLoadingView()
                    self?.requestXACIDKey(browserData)
                }
            }
        } else {
            displayLoadingView()
            requestXACIDKey(browserData)
        }
    }
   
    func requestXACIDKey(_ browserData: BrowserData) {
        let requestURL = RequestURL(requestType: .get, action: browserData.action)
        
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            
            guard let res = response as? HTTPURLResponse else { return }
            
            if let xacid = res.allHeaderFields["X-ACID"] as? String {
                if browserData.action! == "reg" {
                    self?.registerDevice(with: xacid)
                } else if browserData.action! == "log" {
                    self?.authenticate(with: xacid)
                }
            } else {
                DispatchQueue.main.async {
                    self?.debuggingTextField.text = "Could not get xacid"
                }
            }
            
        })
    }
    
    func registerDevice(with xacid: String) {
        let body = identifierManager?.compileSources()
        var requestURL = RequestURL(requestType: .post, body: body, xacid: xacid, action: browserData!.action)
        requestURL.userIDAndPassword = browserData?.encData ?? "encData nil"
        
        networkManager?.call(requestURL, completion: { (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            
            if (200...299) ~= res.statusCode {
                DispatchQueue.main.async {
                    self.perform(#selector(self.displayPointerView), with: nil, afterDelay: 1.5)
                }
            } else {
                DispatchQueue.main.async {
                    self.debuggingTextField.text = "Registration Error"
                }
            }
        })
    }
    
    func authenticate(with xacid: String) {
        let body = identifierManager?.compileSources()
        var requestURL = RequestURL(requestType: .post, body: body, xacid: xacid, action: browserData!.action)
        requestURL.userIDAndPassword = browserData?.encData ?? "encData nil"
        
        networkManager?.call(requestURL, completion: { (data, response, error) in
            
            guard let res = response as? HTTPURLResponse else { return }
     
            if (200...299) ~= res.statusCode {
                DispatchQueue.main.async {
                    self.perform(#selector(self.displayPointerView), with: nil, afterDelay: 0.75)
                }
            } else {
                DispatchQueue.main.async {
                    self.debuggingTextField.text = "Auth Error"
                }
            }
        })
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
