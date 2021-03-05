//
//  RegisterViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 1/21/21.
//

import UIKit

final class RegisterViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .onDrag
        
    }
    
    @IBAction func register() {
        let browserData = BrowserData(action: "log", uid: "uuid", nonce: "ryay5sflif")
        let id = IdentifierManager(browserData)
        
        let obj = RegistrationObject(email: "garciacy@invysta.com",
                                     password: "123321",
                                     caid: id.createClientAgentId(),
                                     otc: "1234",
                                     identifiers: id.compiledSources)
        let reg = RegisterLayer(obj)
        reg.register()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
