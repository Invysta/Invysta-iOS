//
//  PrivacyPolicyItem.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/7/20.
//

import UIKit
import SafariServices

struct PrivacyPolicyItem: SettingItem {
    var settingTitle: String = "Privacy Policy"
    
    var settingDetails: String?
    
    var showIndicator: UITableViewCell.AccessoryType = .disclosureIndicator
    
    var highlightWhenTapped: Bool = true
    
    func action(_ object: Any?) {
        let vc = object as? UIViewController
        let url = URL(string: "https://invystasafe.com")!
        let sf = SFSafariViewController(url: url)
        vc?.present(sf, animated: true, completion: nil)
    }
    
    
}
