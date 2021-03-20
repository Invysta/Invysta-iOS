//
//  RegisterViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 1/21/21.
//

import UIKit

final class RegisterViewController: UITableViewController {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var otcField: UITextField!
    @IBOutlet var providerField: UITextField!

    @IBOutlet var firstContentView: UIView!
    @IBOutlet var secondContentView: UIView!
    @IBOutlet var thirdContentView: UIView!
    @IBOutlet var fourthContentView: UIView!
    
    private let identifierManagers = IdentifierManager()
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 45
        tableView.keyboardDismissMode = .onDrag
        initUI()
    }
    
    func initUI() {
        [firstContentView, secondContentView, thirdContentView, fourthContentView].forEach { (element) in
            element?.layer.borderWidth = 1.5
            element?.layer.cornerRadius = 10
            
            if #available(iOS 13.0, *) {
                element?.layer.borderColor = UIColor.systemFill.cgColor
            } else {
                element?.layer.borderColor = UIColor.lightText.cgColor
            }
        }
    }
    
    @IBAction func register() {
        guard let email = emailField.text, let password = passwordField.text, let otc = otcField.text else { return }
        let obj = RegistrationObject(email: email,
                                     password: password,
                                     caid: identifierManagers.createClientAgentId(),
                                     otc: otc,
                                     identifiers: identifierManagers.compiledSources)
        
        let urlObj = InvystaURL(object: obj)
        
        networkManager.call(urlObj) { [weak self] (data, res, error) in
            
            guard let res = res as? HTTPURLResponse else { return }
            
            if res.statusCode == 201 {
                let cancel = UIAlertAction(title: "Okay", style: .default) { [weak self] (_) in
                    UserDefaults.standard.setValue(true, forKey: UserdefaultKey.isExistingUser.rawValue)
                    self?.dismiss(animated: true)
                }
                self?.alert("Success!", "Device successfully registered", cancel)
            } else {
                if let data = data, let jsonResponse = try? JSONDecoder().decode(InvystaError.self, from: data) {
                    
                    let errorTitle: String = jsonResponse.error
                    var errorDetails: String?
                    
                    if let errors = jsonResponse.errors {
                        errorDetails = ""
                        for error in errors {
                            errorDetails! += error.param + " " + error.msg
                        }
                    }
                    
                    self?.alert(errorTitle, errorDetails)
                }
            }
            
        }
    }
    
    func alert(_ title: String,_ message: String?,_ action: UIAlertAction = UIAlertAction(title: "Cancel", style: .default)) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(action)
            self?.present(alert, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
