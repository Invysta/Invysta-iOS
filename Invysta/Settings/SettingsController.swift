//
//  SettingsController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/18/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

protocol SettingItem {
    var settingTitle: String { get }
    var settingDetails: String? { get }
    var showIndicator: UITableViewCell.AccessoryType { get }
    var highlightWhenTapped: Bool { get }
    func action(_ object: Any?)
}

protocol SettingSectionDelegate {
    var sectionTitle: String { get }
    var settingItems: [SettingItem] { get }
}

struct AppInfoSection: SettingSectionDelegate {
    var sectionTitle: String = "App Info"
    var settingItems: [SettingItem]

    init() {
        settingItems = [AppVersionItem(), PrivacyPolicyItem()]
    }
}

final class SettingsCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var sections = [SettingSectionDelegate]()
    
    private let tableView: UITableView = {
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
    
    func prepareSections() {
        sections = [AppInfoSection()]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.white
        }
        
        initUI()
        prepareSections()
    }
    
    func initUI() {
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].settingItems[indexPath.row].action(self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].settingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sectionItem = sections[indexPath.section].settingItems[indexPath.row]
        
        cell.textLabel?.text = sectionItem.settingTitle
        cell.detailTextLabel?.text = sectionItem.settingDetails
        cell.accessoryType = sectionItem.showIndicator
        
        return cell
    }
        
}
