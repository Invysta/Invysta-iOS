//
//  ActivityViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 12/10/20.
//

import UIKit

final class ActivityCellViewController: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ActivityViewController: UITableViewController, ActivitySettingsViewControllerDelegate {
    
    var activity = [Activity]()
    let coreDataManager = PersistenceManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity = coreDataManager.fetch(Activity.self).reversed()
        
        tableView.register(ActivityCellViewController.self, forCellReuseIdentifier: "cell")
        title = "Activity"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationBarItems()
        
    }
    
    func navigationBarItems() {
        let infoButton = UIButton(type: .infoDark)
        infoButton.addTarget(self, action: #selector(showActivitySettings), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
    }
    
    @objc
    func showActivitySettings() {
        let vc = ActivitySettingsViewController()
        vc.delegate = self
        
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationItem.largeTitleDisplayMode = .always
        present(nav, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activityDetailsViewController = ActivityDetailViewController()
        activityDetailsViewController.activity = activity[indexPath.row]
        show(activityDetailsViewController, sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activity.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let obj = activity[indexPath.row]
        
        cell.textLabel?.text = obj.title
        cell.detailTextLabel?.text = obj.date?.timeIntervalSince1970.date(.fullDate) ?? ""
        return cell
    }
    
    func didDeleteAllItems() {
        activity.removeAll()
        tableView.reloadData()
    }
     
}

extension Double {
    public enum TimestampFormat: String {
        case halfDate = "E, MMM d"
        case fullDate = "MMMM d, yyyy, h:mm a"
        case time = "h:mm a"
        case hour = "h a"
        case day = "EEEE"
    }
    
    public func date(_ format: TimestampFormat, _ timezone: TimeZone? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = timezone ?? TimeZone.current
        dateFormatter.locale = Locale.autoupdatingCurrent
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}

