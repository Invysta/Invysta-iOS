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
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let browserData = browserData else { return }
        
        let obj = AuthenticationObject(uid: browserData.uid,
                                       nonce: browserData.nonce,
                                       caid: identifierManager.createClientAgentId(),
                                       identifiers: identifierManager.compiledSources)
        
        present(AuthenticationViewController(obj), animated: true)
        
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
