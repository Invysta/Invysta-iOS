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
        
        if FeatureFlagBrowserData().trigger {
            displayLoadingView()
            authenticate(with: "123321", browserData!)
            return
        }
        
        if FeatureFlag.mockSuccessLabel {
            displayLoadingView()
        } else {
            beginInvystaProcess(with: browserData)
        }
        
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
        
        guard UserDefaults.standard.bool(forKey: "DeviceSecurity") else {
            requestXACIDKey(browserData)
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Begin Invysta Authentication") { [weak self] (success, error) in
            DispatchQueue.main.async {
                if success {
                    self?.requestXACIDKey(browserData)
                }
            }
        }
       
    }
   
    func requestXACIDKey(_ browserData: BrowserData) {
        displayLoadingView()
        
        let requestURL = RequestURL(requestType: .get, browserData: browserData)
        
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            
            guard let res = response as? HTTPURLResponse else { return }
            
            if let xacid = res.allHeaderFields["X-ACID"] as? String {
               
                if browserData.action == "reg" {
                    self?.registerDevice(with: xacid, browserData)
                } else if browserData.action == "log" {
                    self?.authenticate(with: xacid, browserData)
                }
            } else {
                DispatchQueue.main.async {
                    self?.debuggingTextField.text = "Could not get xacid"
                    self?.removeLoadingView()
                }
            }
            
        })
    }
    
    func registerDevice(with xacid: String,_ browserData: BrowserData) {
        let body = identifierManager?.compileSources()
        let requestURL = RequestURL(requestType: .post,
                                    browserData: browserData,
                                    body: body,
                                    xacid: xacid)
        
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            self?.networkManagerResponse(with: res)
        })
    }
    
    func authenticate(with xacid: String,_ browserData: BrowserData) {
        let body = identifierManager?.compileSources()
        let requestURL = RequestURL(requestType: .post,
                                    browserData: browserData,
                                    body: body,
                                    xacid: xacid)
        
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            self?.networkManagerResponse(with: res)
        })
    }
    
    private func networkManagerResponse(with response: HTTPURLResponse) {
        DispatchQueue.main.async { [weak self] in
            if (200...299) ~= response.statusCode {
                self?.perform(#selector(self!.successfulRequest), with: self, afterDelay: 1.5)
            } else {
                self?.debuggingTextField.text = "Status Code: \(response.statusCode)"
                self?.perform(#selector(self!.failedRequest), with: self, afterDelay: 1.5)
            }
        }
        
    }
 
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
