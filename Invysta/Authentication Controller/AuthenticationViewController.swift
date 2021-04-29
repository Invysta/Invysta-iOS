//
//  AuthenticationViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 3/5/21.
//

import InvystaCore
import LocalAuthentication
import UIKit

final class AuthenticationViewController: UIViewController {
    
    private let process: InvystaProcess<AuthenticationModel>
    private var error: NSError?
    
    private let laContext: LAContext = LAContext()
    private let coreDataManager: PersistenceManager = PersistenceManager.shared
    
    init(_ model: AuthenticationModel) {
//        authentication = Authenticate(authObject, IVUserDefaults.getString(.providerKey)!)
        process = InvystaProcess<AuthenticationModel>(model, IVUserDefaults.getString(.providerKey)!)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Authenticating"
        label.font = .systemFont(ofSize: 35)
        label.numberOfLines = 0
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
        
        guard IVUserDefaults.getBool(.DeviceSecurity) else {
            beginAuthenticationProcess()
            return
        }
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            deviceAuthentication(with: .deviceOwnerAuthenticationWithBiometrics)
        } else {
            deviceAuthentication(with: .deviceOwnerAuthentication)
        }
    }
    
    func deviceAuthentication(with policy: LAPolicy) {
        laContext.evaluatePolicy(policy, localizedReason: "Authenticate to begin the Invysta Authentication Process") { [weak self] (success, error) in
            DispatchQueue.main.async {
                if success {
                    self?.beginAuthenticationProcess()
                } else {
                    self?.showResults(error?.localizedDescription ?? "Login Failed")
                }
            }
        }
    }
    
    func beginAuthenticationProcess() {
        
        process.start { [weak self] (results) in
             
            switch results {
            case .success(let statusCode):
                
                self?.showResults("Login Successful!")
                self?.saveActivity(title: "Login Successful", message: "", statusCode: statusCode)
                
                InvystaService.log(.check,"\(type(of: self))", "Login Successful")
                
                DispatchQueue.main.async {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    NotificationCenter.default.post(name: Notification.displayPointer(), object: nil)
                }
                
            case .failure(let error, let statusCode):
                
                self?.showResults(error)
                self?.saveActivity(title: error, message: "", statusCode: statusCode)
                
                DispatchQueue.main.async {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
                
                break
                
            }
        }
        
    }
    
    func showResults(_ text: String) {
        
        DispatchQueue.main.async { [weak activityIndicatorView, unowned titleLabel] in
            
            activityIndicatorView?.stopAnimating()
            
            UIView.transition(with: titleLabel, duration: 1.0, options: [.curveEaseInOut,.transitionFlipFromBottom]) {
                titleLabel.text = text
            } completion: { [weak self] (_) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    func saveActivity(title: String, message: String, statusCode: Int) {
        let activityManager = ActivityManager(coreDataManager)
        let activity = Activity(context: coreDataManager.context)
        activity.date = Date()
        activity.title = title
        activity.message = message
        activity.type = "Login"
        activity.statusCode = Int16(statusCode)
        
        activityManager.saveResults(activity: activity)
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
    
    deinit {
        InvystaService.reclaimedMemory(self)
    }
}

//https://provider.invysta-technical.com/interaction/fUmSR3GUsGr3Brlo0_pB0?client=true
//https://provider.invysta-technical.com/interaction/fUmSR3GUsGr3Brlo0_pB0?client=true
