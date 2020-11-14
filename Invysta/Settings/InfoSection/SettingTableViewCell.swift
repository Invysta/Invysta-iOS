//
//  SettingTableViewCell.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/13/20.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
