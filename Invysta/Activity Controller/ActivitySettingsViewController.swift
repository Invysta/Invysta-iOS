//
//  ActivitySettingsViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 12/15/20.
//

import UIKit
import Invysta_Framework

protocol ActivitySettingsViewControllerDelegate: AnyObject {
    func didDeleteAllItems()
}

final class ActivitySettingsViewController: UITableViewController {
    
    weak var delegate: ActivitySettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        title = "Activity"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissController))
    }
    
    @objc
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section != 1 { return }
        
        let alert = UIAlertController(title: "Clear All Data", message: "Are you sure you want to clear all your recent invysta activity? This action is irreversible.", preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: "Clear All", style: .destructive) { [weak self] (_) in
            PersistenceManager.shared.deleteAll()
            self?.delegate?.didDeleteAllItems()
            self?.dismissController()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [0,1][section]
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "This is a log of all your recent login activity with this device. All information are stored locally and never leave the device!"
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 1 {
            cell.textLabel?.text = "Clear All Activity"
            cell.textLabel?.textColor = .red
        }
        
        return cell
    }
    
    deinit {
        InvystaService.reclaimedMemory(self)
    }
}
