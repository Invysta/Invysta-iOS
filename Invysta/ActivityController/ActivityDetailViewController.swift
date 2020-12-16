//
//  ActivityDetailViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 12/15/20.
//

import UIKit

final class ActivityDetailViewController: UITableViewController {
    
    var activity: Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        tableView.register(ActivityCellViewController.self, forCellReuseIdentifier: "cell")
    }
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Website", "Date", activity!.title, "Status Code"][section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 2 { return }
        let alert = UIAlertController(title: activity!.title, message: activity!.message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancel)
        
        present(alert, animated: true) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell.textLabel?.text = activity?.website?.host ?? ""
        } else if indexPath.section == 1 {
            cell.textLabel?.text = activity?.date?.timeIntervalSince1970.date(.fullDate)
        } else if indexPath.section == 2 {
            cell.textLabel?.text = activity!.message
            cell.selectionStyle = .default
        } else if indexPath.section == 3 {
            cell.textLabel?.text = "\(activity!.statusCode)"
        }
        
        return cell
    }
    
}
