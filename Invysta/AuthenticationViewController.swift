//
//  AuthenticationViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 3/5/21.
//

import UIKit

final class AuthenticationViewController: UIViewController {
    
    private let authObject: AuthenticationObject
    private var networkManager: NetworkManager?
    
    init(_ authObject: AuthenticationObject,_ networkManager: NetworkManager = NetworkManager()) {
        self.authObject = authObject
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Authenticating"
        label.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: .systemFont(ofSize: 25))
        return label
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        return indicator
    }()
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        networkManager?.call(InvystaURL(object: authObject), completion: { (data, response, error) in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject] {
                print(jsonObj)
            }
            
            if let response = response as? HTTPURLResponse {
                print("status code",response.statusCode)
                
                if response.statusCode == 400 {
                    
                } else if response.statusCode == 201 {
                    self.dismiss(animated: true)
                }
            }
        })
    }
    
    func initUI() {
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        containerStack.addArrangedSubview(titleLabel)
        containerStack.addArrangedSubview(activityIndicatorView)
        
        view.addSubview(containerStack)
        
        NSLayoutConstraint.activate([
            containerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            containerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
        
        view.layoutIfNeeded()
    }
}
