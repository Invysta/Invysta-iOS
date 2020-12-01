//
//  ViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import LocalAuthentication

class ViewController: BaseViewController {

    private(set)  var identifierManager: IdentifierManager?
    private(set) var networkManager: NetworkManager?
    
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
            
            guard let res = response as? HTTPURLResponse,
                  let xacid = res.allHeaderFields["X-ACID"] as? String else {
                self?.response(with: "Error",
                               and: "Something went wrong and unable to retrieve X-ACID key. Please try again.",
                               false)
                return
            }
            
            switch browserData.callType {
            case .login:
                self?.authenticate(with: xacid, browserData)
            case .register:
                self?.registerDevice(with: xacid, browserData)
            default:
                return
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
            guard let res = response as? HTTPURLResponse else {
                self?.response(with: "Error", and: "Something went wrong. Please try again later.", false)
                return
            }
            
            if (200...299) ~= res.statusCode {
                self?.response(with: "Registration Complete!", and: "You can now safely return to your app.", false)
            } else {
                self?.response(with: "Registration Failed", and: "", false)
            }
            
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
            guard let res = response as? HTTPURLResponse else {
                self?.response(with: "Error", and: "Something went wrong. Please try again later.", false)
                return
            }
            
            if (200...299) ~= res.statusCode {
                self?.response(with: "Successfully Logged In!", and: "You can now safely return to your app.")
            } else if res.statusCode == 401 {
                self?.response(with: "Login Failed.", and: "Username or password me be incorrect, or your device is not registered.")
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
