//
//  AppVersionItem.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/7/20.
//

import UIKit

struct AppVersionItem: SettingItem {
    
    var cellHeight: CGFloat = 50
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        cell.textLabel?.text = "App Version"
        cell.detailTextLabel?.text = appVersion ?? "na"
        cell.selectionStyle = .none
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {}
    
}
