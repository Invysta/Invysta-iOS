//
//  SettingManager.swift
//  Invysta
//
//  Created by Cyril Garcia on 8/19/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

protocol SettingItem {
    var cellHeight: CGFloat { get }
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
    func performSelector(_ vc: UIViewController)
}

protocol SectionItem {
    var title: String { get }
    var cells: [SettingItem] { get }
}

final class SettingManager {
    
    var sections = [SectionItem]()
    var cells = [CellType]()
    
    init() {
        sections = [AppInfoSection(), AppSecuritySection()]
        cells = [CellType(cell: SettingsTableViewCell.self, id: "SettingsTableViewCell"),
                 CellType(cell: DeviceSecurityCell.self, id: "DeviceSecurityCell")]
    }
    
    func cellRegistration(to tableView: UITableView) {
        for cell in cells {
            tableView.register(cell.cell, forCellReuseIdentifier: cell.id)
        }
    }
}

struct AppSecuritySection: SectionItem {
    var title: String = "Device Security"
    var cells: [SettingItem] = [DeviceSecurityItem(), ReregisterDeviceItem()]
}

struct AppInfoSection: SectionItem {
    var title: String = "Info"
    var cells: [SettingItem] = [AppVersionItem(), PrivacyPolicyItem()]
}

struct CellType {
    var cell: UITableViewCell.Type
    var id: String
}
