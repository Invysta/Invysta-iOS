//
//  ActivityViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 12/10/20.
//

import UIKit

struct IVHistory: Codable {
    var date: Date
    var website: URL
    var success: Bool
}

final class ActivityViewController: UITableViewController {
    
    var history = [IVHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        history = [IVHistory(date: Date(), website: URL(string: "https://somewebsite.com")!, success: true),
                   IVHistory(date: Date(), website: URL(string: "https://example.com")!, success: true)]
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        title = "Activity"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationBarItems()
    }
    
    func navigationBarItems() {
        let infoButton = UIButton(type: .infoDark)
        infoButton.addTarget(self, action: #selector(infoAlert), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
    }
    
    @objc
    func infoAlert() {
        let alert = UIAlertController(title: "Activity", message: "This is a log of all your recent login activity with this device. All information are stored locally and never leave the device!", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let obj = history[indexPath.row]
        
        cell.textLabel?.text = "Website: \(obj.website.host)"
        
        return cell
    }
    
}
