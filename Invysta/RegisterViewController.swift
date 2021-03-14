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
        print(obj.caid)
        
        RegisterLayer(obj).register()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
