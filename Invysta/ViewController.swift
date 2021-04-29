//
//  ViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import LocalAuthentication
import InvystaCore

class ViewController: BaseViewController {
    
    private var error: NSError?
    private let context = LAContext()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    //    MARK: Entry Point from Browser
    init(_ browserData: ProviderModel) {
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
        if IVUserDefaults.getBool(.isExistingUser) { return }
        
        guard let registerViewController = UIStoryboard(name: "RegisterViewStoryboard", bundle: .main).instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else { return }
        
        let nav = UINavigationController(rootViewController: registerViewController)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationItem.largeTitleDisplayMode = .always
        
        if #available(iOS 13.0, *) {
            nav.isModalInPresentation = true
        }
        
        present(nav, animated: true)
        
    }
    
    func beginAuthProcess(_ browserData: ProviderModel) {
        
        let obj = AuthenticationModel(uid: browserData.uid,
                                      nonce: browserData.nonce)
        
        InvystaService.log(.alert, "\(type(of: self))", IdentifierManager.shared.compiledSources)
        
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
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
