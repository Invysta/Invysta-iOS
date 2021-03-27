//
//  SettingsController.swift
//  Invysta
//
//  Created by Cyril Garcia on 8/18/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class SettingsController: UITableViewController {
    
    init() {
        if #available(iOS 13.0, *) {
            super.init(style: .insetGrouped)
        } else {
            super.init(style: .grouped)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let settingManager = SettingManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingManager.cellRegistration(to: tableView)

        title = "Settings"
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingManager.sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return settingManager.sections[indexPath.section].cells[indexPath.row].cellHeight
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingManager.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingManager.sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingManager.sections[indexPath.section].cells[indexPath.row].performSelector(self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return settingManager.sections[indexPath.section].cells[indexPath.row].createCell(in: tableView, for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    deinit {
        reclaimedMemory()
    }
    
    func reclaimedMemory(_ fileName: String = #file,
                         _ funcName: String = #function,
                         _ lineNumber: Int = #line) {
        
        Swift.print("")
        Swift.print("##########")
        Swift.print("Reclaimed memory")
        Swift.print("CLASS:",String(describing: type(of: self)))
        Swift.print("##########")
        Swift.print("")
    }
}
