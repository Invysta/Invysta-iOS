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

//    MARK: Entry Point from Browser
    init(_ browserData: BrowserData,
         _ identifierManager: IdentifierManager? = nil,
         _ networkManager: NetworkManager = NetworkManager()) {
        super.init(nibName: nil, bundle: nil)
        
        self.networkManager = networkManager
        self.browserData = browserData
        
        if let identifierManager = identifierManager {
            self.identifierManager = identifierManager
        } else {
            self.identifierManager = IdentifierManager(browserData)
        }
    }
   
//    MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        if FeatureFlagBrowserData().trigger {
            displayLoadingView()
            authenticate(with: "123321", browserData!)
            return
        }
        
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
    
//    MARK: Begin Invysta Process
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
   
//    MARK: Request XACID
    func requestXACIDKey(_ browserData: BrowserData) {
        displayLoadingView()
        
        let requestURL = RequestURL(requestType: .get, browserData: browserData)
        
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            
            guard let res = response as? HTTPURLResponse else { return }
            
            if let xacid = res.allHeaderFields["X-ACID"] as? String {
               
                switch browserData.callType {
                case .login:
                    self?.authenticate(with: xacid, browserData)
                case .register:
                    self?.registerDevice(with: xacid, browserData)
                default:
                    return
                }
                
            } else {
                DispatchQueue.main.async {
                    self?.debuggingTextField.text = "Could not get xacid"
                    self?.displayMessage(title: "Error", message: "Something went wrong and unable to retrieve X-ACID key. Please try again.")
                    self?.removeLoadingView()
                }
            }
            
        })
    }
    
//    MARK: Register Device with XACID
    func registerDevice(with xacid: String,_ browserData: BrowserData) {
        let body = identifierManager?.compiledSources
        let requestURL = RequestURL(requestType: .post,
                                    browserData: browserData,
                                    body: body,
                                    xacid: xacid)
        
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            self?.networkManagerResponse(with: res)
        })
    }
    
//    MARK: Authenticate with XACID
    func authenticate(with xacid: String,_ browserData: BrowserData) {
        let body = identifierManager?.compiledSources
        let requestURL = RequestURL(requestType: .post,
                                    browserData: browserData,
                                    body: body,
                                    xacid: xacid)
        
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            self?.networkManagerResponse(with: res)
        })
    }
    
//    MARK: Network Response
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
