//
//  ViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import AdSupport

class ViewController: UIViewController, NetworkManagerDelegate {

    private var identifierManager: IdentifierManager?
    private var networkManager: NetworkManager?
    private var browserData: BrowserData?
    
    private let appVersionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var url: URL?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(_ browserData: BrowserData) {
        super.init(nibName: nil, bundle: nil)
        identifierManager = IdentifierManager(browserData, [VendorIdentifier(), AdvertiserIdentifier()])
        self.browserData = browserData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager = NetworkManager()
        networkManager?.delegate = self
        displayAppVersion()
        
        
        let requestURL = RequestURL(callType: .login,
                                    requestType: .get)
        
        networkManager?.call(requestURL)
    }
    
    func getReqReg() {
        guard let browserData = self.browserData else{ return }
        executeCommonGet(browserData)
    }
    
    func executeCommonGet(_ browserData: BrowserData) {
        var requestURL: RequestURL
        
        if browserData.action == "log" {
            requestURL = RequestURL(callType: .login, requestType: .get)
        } else {
            requestURL = RequestURL(callType: .register, requestType: .get)
        }
        
        networkManager?.call(requestURL)
    }
    
    func networkResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        
        guard let res = response as? HTTPURLResponse else { return }
        let xacid = res.allHeaderFields["X-ACID"] as? String
        print(res)
        print(xacid)
    }
    
    func displayAppVersion() {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }

        view.addSubview(appVersionLabel)
        appVersionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 15
        let height: CGFloat = 50
        
        NSLayoutConstraint.activate([
            appVersionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            appVersionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            appVersionLabel.heightAnchor.constraint(equalToConstant: height),
            appVersionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding + 5)
        ])
        view.layoutIfNeeded()
        
        appVersionLabel.text = "App Version: " + appVersion
    }

}
