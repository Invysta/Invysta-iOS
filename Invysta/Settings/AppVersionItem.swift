//
//  AppVersionItem.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/7/20.
//

import UIKit

struct AppVersionItem: SettingItem {
    var settingTitle: String
    var settingDetails: String?
    var showIndicator: UITableViewCell.AccessoryType = .none
    var highlightWhenTapped: Bool = false
    
    init() {
        settingTitle = "App Version"
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        settingDetails = appVersion ?? "na"
    }
    
    func action(_ object: Any?) {}
}
