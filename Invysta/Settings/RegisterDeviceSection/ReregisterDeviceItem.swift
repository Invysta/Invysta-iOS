//
//  ReregisterDeviceItem.swift
//  Invysta
//
//  Created by Cyril Garcia on 3/25/21.
//

import UIKit

struct ReregisterDeviceItem: SettingItem {
    
    var cellHeight: CGFloat = UITableView.automaticDimension
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = "Reregister Device"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {
        guard let registerViewController = UIStoryboard(name: "RegisterViewStoryboard", bundle: .main).instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else { return }
        
        let nav = UINavigationController(rootViewController: registerViewController)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationItem.largeTitleDisplayMode = .always
        
        vc.present(nav, animated: true)
    }
    
}
