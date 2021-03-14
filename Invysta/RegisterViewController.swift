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
    
    private let identifierManagers = IdentifierManager()
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .onDrag
        
    }
    
    @IBAction func register() {
        
        let obj = RegistrationObject(email: emailField.text ?? "",
                                     password: passwordField.text ?? "",
                                     caid: identifierManagers.createClientAgentId(),
                                     otc: "1234",
                                     identifiers: identifierManagers.compiledSources)
        
        let urlObj = InvystaURL(object: obj)
        
        networkManager.call(urlObj) { (data, res, error) in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject] {
                print(jsonObj)
            }
            
            if let res = res as? HTTPURLResponse {
                print("status code",res.statusCode)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
