//
//  ViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import LocalAuthentication

class ViewController: BaseViewController {
    
    private(set) var identifierManager: IdentifierManager  = IdentifierManager()
    private(set) var networkManager: NetworkManager = NetworkManager()
    
    private var error: NSError?
    private let context = LAContext()
    
    init(_ browserData: BrowserData) {
        super.init(nibName: nil, bundle: nil)
        self.browserData = browserData
    }
    
    //    MARK: Entry Point from Browser
    init(_ browserData: BrowserData,
         _ identifierManager: IdentifierManager,
         _ networkManager: NetworkManager) {
        
        self.networkManager = networkManager
        self.identifierManager = identifierManager
        
        super.init(nibName: nil, bundle: nil)
        self.browserData = browserData
    }
    
    //    MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(displayPointerView),
                                               name: Notification.displayPointer(),
                                               object: nil)
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        if let browserData = browserData {
            beginAuthProcess(browserData)
        } else {
            beginRegistration()
        }
    }
    
    func beginRegistration() {
        
        if UserDefaults.standard.bool(forKey: UserdefaultKey.isExistingUser.rawValue) == true { return }
        
        let registerViewController = UIStoryboard(name: "RegisterViewStoryboard", bundle: .main).instantiateViewController(withIdentifier: "RegisterViewController")
        if #available(iOS 13.0, *) {
            registerViewController.isModalInPresentation = true
        }
        present(registerViewController, animated: true)
        
    }
    
    func beginAuthProcess(_ browserData: BrowserData) {
        
        let obj = AuthenticationObject(uid: browserData.uid,
                                       nonce: browserData.nonce,
                                       caid: identifierManager.createClientAgentId(),
                                       identifiers: identifierManager.compiledSources)
        
        let authViewController = AuthenticationViewController(obj)
        
        if #available(iOS 13.0, *) {
            authViewController.isModalInPresentation = true
        }
        
        present(authViewController, animated: true) { [weak self] in
            self?.browserData = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pointerView.play()
    }
  
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
