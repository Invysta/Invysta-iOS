//
//  AuthenticationViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 3/5/21.
//

import InvystaCore
import UIKit

final class AuthenticationViewController: UIViewController, LocalAuthenticationManagerDelegate {
    
    private let process: InvystaProcess<AuthenticationModel>
    private let queue: DispatchQueue
    
    private let coreDataManager: PersistenceManager = PersistenceManager.shared
    private let localAuth: LocalAuthenticationManager = LocalAuthenticationManager()
    
    init(_ process: InvystaProcess<AuthenticationModel>, _ queue: DispatchQueue = DispatchQueue.main) {
        self.process = process
        self.queue = queue
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
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
        localAuth.delegate = self
        localAuth.beginLocalAuthentication(beginAuthenticationProcess)
    }
    
    func beginAuthenticationProcess() {
        
        process.start { [weak self] (results) in
            
            switch results {
            case .success(let statusCode):
                
                self?.showResults("Login Successful!")
                self?.saveActivity(title: "Login Successful", message: "", statusCode: statusCode)
                
                InvystaService.log(.check,"\(type(of: self))", "Login Successful")
                
                self?.queue.async {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    NotificationCenter.default.post(name: Notification.displayPointer(), object: nil)
                }
                
            case .failure(let error, let statusCode):
                
                self?.showResults(error)
                self?.saveActivity(title: error, message: "", statusCode: statusCode)
                
                self?.queue.async {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
                break
            }
        }
        
    }
    
    func localAuthenticationDidFail(_ error: Error?) {
        showResults(error?.localizedDescription ?? "No Error Description Available")
    }
    
    func showResults(_ text: String) {
        
        queue.async { [weak activityIndicatorView, unowned titleLabel] in
            
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
