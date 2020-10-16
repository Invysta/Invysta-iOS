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
    
    init(_ url: URL?) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayAppVersion()
        login()
    }
    
    func login() {

        let requestURL = RequestURL(type: .register, params: ["caid":"mock-data"])
        networkManager = NetworkManager()
        networkManager?.delegate = self
        networkManager?.call(requestURL, .get)

    }
    
    func networkResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        guard let data = data else { return }
        
        let str = String(decoding: data, as: UTF8.self)
        print(str)
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
