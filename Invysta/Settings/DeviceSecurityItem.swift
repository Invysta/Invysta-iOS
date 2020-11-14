//
//  DeviceSecurityItem.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/13/20.
//

import UIKit
import LocalAuthentication

final class DeviceSecurityCell: UITableViewCell {
    
    let toggle = UISwitch()
    let context = LAContext()
    var error: NSError?

    var deviceAuthenticationIsOn = UserDefaults.standard.bool(forKey: "DeviceSecurity")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "DeviceSecurityCell")
        customUI()
        checkSecurityType()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customUI() {

        textLabel?.text = "Device Security"
        
        let padding: CGFloat = 10
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.setOn(UserDefaults.standard.bool(forKey: "DeviceSecurity"), animated: false)
        toggle.addTarget(self, action: #selector(turnOnDeviceSecurity(_:)), for: .valueChanged)
        addSubview(toggle)
        
        NSLayoutConstraint.activate([toggle.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     toggle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)])
        
        layoutIfNeeded()
    }
    
    func checkSecurityType() {
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            switch context.biometryType {
            case .faceID:
                detailTextLabel?.text = "Enable FaceID"
            case .touchID:
                detailTextLabel?.text = "Enable TouchID"
            default:
                return
            }
        }
    }
    
    @objc
    func turnOnDeviceSecurity(_ tog: UISwitch) {
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authorize Invysta to Authenticate") { (success, error) in
            DispatchQueue.main.async { [weak self] in
                
                if success == false {
                    self?.toggle.setOn(self!.deviceAuthenticationIsOn, animated: true)
                } else {
                    self?.deviceAuthenticationIsOn = success
                    self?.toggle.setOn(tog.isOn, animated: true)
                    UserDefaults.standard.setValue(tog.isOn, forKey: "DeviceSecurity")
                }
                
            }
        }
    }
}

struct DeviceSecurityItem: SettingItem {
    var cellHeight: CGFloat = 50
    
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceSecurityCell", for: indexPath) as? DeviceSecurityCell else { return UITableViewCell() }
        return cell
    }
    
    func performSelector(_ vc: UIViewController) {}
    
}
