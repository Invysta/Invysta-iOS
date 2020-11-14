//
//  SettingsController.swift
//  Invysta
//
//  Created by Cyril Garcia on 8/18/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class SettingsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let settingTableView: UITableView = {
        var tableView: UITableView
        
        if #available(iOS 13.0, *) {
            tableView = UITableView(frame: .zero, style: .insetGrouped)
            tableView.backgroundColor = UIColor.systemBackground
        } else {
            tableView = UITableView(frame: .zero, style: .grouped)
            tableView.backgroundColor = UIColor.white
        }
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let settingManager = SettingManager()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemGroupedBackground
        } else {
            view.backgroundColor = UIColor.white
        }
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        settingManager.cellRegistration(to: settingTableView)
        title = "Invysta Safe"
    }
    
    func initUI() {
        
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(dismissController))
        navigationItem.leftBarButtonItem = backButton
        
        settingTableView.backgroundColor = .clear
        view.addSubview(settingTableView)
        
        NSLayoutConstraint.activate([
            settingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.layoutIfNeeded()
        
    }
    
    @objc
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingManager.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return settingManager.sections[indexPath.section].cells[indexPath.row].cellHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingManager.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingManager.sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingManager.sections[indexPath.section].cells[indexPath.row].performSelector(self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return settingManager.sections[indexPath.section].cells[indexPath.row].createCell(in: tableView, for: indexPath)
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
