//
//  ViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import AdSupport

class ViewController: UIViewController {

    @IBOutlet var appVersionLabel: UILabel!
    
    private var identifierManager: IdentifierManager?
    private var networkManager: NetworkManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayAppVersion()
   
    }
    
    func displayAppVersion() {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        appVersionLabel.text = "App Version\n" + appVersion
    }

}
