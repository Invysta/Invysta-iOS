//
//  PrivacyPolicyItem.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/7/20.
//

import UIKit
import SafariServices

struct PrivacyPolicyItem: SettingItem {
    var cellHeight: CGFloat = 50
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        
        cell.textLabel?.text = "Privacy Policy"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {
        let url = URL(string: "https://invysta.com/privacy-policy")!
        let sf = SFSafariViewController(url: url)
        vc.present(sf, animated: true, completion: nil)
    }
    
}
