//
//  ViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import LocalAuthentication

class ViewController: BaseViewController {
    
    private(set) var identifierManager: IdentifierManager?
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
        
        if let browserData = browserData {
            print(browserData.see)
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
