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
        label.font = .systemFont(ofSize: 35)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
                    self.showResults("Login Failed")
                } else if response.statusCode == 201 {
                    self.showResults("Login Successful!")
                }
            }
        })
    }
    
    func showResults(_ text: String) {
        let titleLabel = self.titleLabel
        
        DispatchQueue.main.async { [weak self] in
            
            self?.activityIndicatorView.stopAnimating()
            
            UIView.transition(with: titleLabel, duration: 1.0, options: [.curveEaseInOut,.transitionFlipFromTop]) {
                titleLabel.text = text
            } completion: { [weak self] (_) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    func initUI() {
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        view.addSubview(titleLabel)
        view.addSubview(activityIndicatorView)
      
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            activityIndicatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            activityIndicatorView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor)
        ])
        
        view.layoutIfNeeded()
    }
}
