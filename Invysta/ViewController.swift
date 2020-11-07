//
//  ViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    private var identifierManager: IdentifierManager?
    private var networkManager: NetworkManager?
    private var browserData: BrowserData?
    
    private let appVersionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let loadingView: AnimationView = {
        let view = AnimationView()
        view.animation = Animation.named("loading")
        view.animationSpeed = 1
        view.loopMode = .loop
        view.play()
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(_ browserData: BrowserData) {
        super.init(nibName: nil, bundle: nil)
        networkManager = NetworkManager()
        identifierManager = IdentifierManager(browserData, [
                                                VendorIdentifier(),
                                                AdvertiserIdentifier(),
                                                CustomIdentifier()])
        self.identifierManager?.magic = browserData.magic
        self.browserData = browserData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayAppVersion()
        
        if let browserData = self.browserData {
            displayLoadingView()
            requestXACIDKey(browserData)
            
            if FeatureFlag.showDebuggingTextField {
                let text = """
                            action: \(browserData.action)\n
                            encData: \(browserData.encData)\n
                            magic: \(browserData.magic ?? "na")\n
                            oneTimeCode: \(browserData.oneTimeCode)
                    """
                createDebuggingField(text)
            }
            
        }
    }
 
    func requestXACIDKey(_ browserData: BrowserData) {
        let requestURL = RequestURL(requestType: .get, action: browserData.action)
        networkManager?.call(requestURL, completion: { [weak self] (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            if let xacid = res.allHeaderFields["X-ACID"] as? String {
                print("Action",requestURL.action)
                if requestURL.action! == "reg" {
                    self?.registerDevice(with: xacid)
                } else if requestURL.action! == "log" {
                    self?.authenticate(with: xacid)
                }
                
            }
        })
    }
    
    func registerDevice(with xacid: String) {
        let body = identifierManager?.compileSources()
        print("Body",body)
        var requestURL = RequestURL(requestType: .post, body: body, xacid: xacid, action: "reg")
        requestURL.userIDAndPassword = browserData?.encData ?? "encData nil"
        
        networkManager?.call(requestURL, completion: { (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            print("results",res,data)
        })
    }
    
    func authenticate(with xacid: String) {
        let body = identifierManager?.compileSources()
        let requestURL = RequestURL(requestType: .post, body: body, xacid: xacid, action: browserData!.action)
        networkManager?.call(requestURL, completion: { (data, response, error) in
            guard let res = response as? HTTPURLResponse else { return }
            print("AuthRes",res)
        })
    }
    
    private func createDebuggingField(_ text: String) {
        let debuggingTextField = UITextView()
        debuggingTextField.text = text
        debuggingTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(debuggingTextField)
        
        NSLayoutConstraint.activate([debuggingTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     debuggingTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     debuggingTextField.heightAnchor.constraint(equalToConstant: 150),
                                     debuggingTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
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
    
    func displayLoadingView() {
        let loadingViewFrame: CGFloat = 200
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([loadingView.heightAnchor.constraint(equalToConstant: loadingViewFrame),
                                     loadingView.widthAnchor.constraint(equalToConstant: loadingViewFrame),
                                     loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        view.layoutIfNeeded()
    }
}
