//
//  BaseViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/13/20.
//

import UIKit
import Lottie

class BaseViewController: UIViewController {
    
    var browserData: BrowserData?

    let debuggingTextField: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
 
    let invystaLogo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var loadingView: LoadingView?
    
    private let pointerView: AnimationView = {
        let view = AnimationView()
        view.animation = Animation.named("pointer-white")
        view.animationSpeed = 2
        view.loopMode = .loop
        view.play()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

//    MARK: InitUI
    func initUI() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.white
        }
        
        displayInvystaLogo()
        displaySettingButton()
    }
        
//    MARK: Move to settings
    @objc
    func moveToSettings() {
        let vc = SettingsController()
        let nav = UINavigationController()
        nav.viewControllers = [vc]
        present(nav, animated: true, completion: nil)
    }
    
//    MARK: Display Message
    func displayInvystaLogo() {
        view.addSubview(invystaLogo)
        
        NSLayoutConstraint.activate([
            invystaLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            invystaLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            invystaLogo.widthAnchor.constraint(equalToConstant: 250),
            invystaLogo.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        view.layoutIfNeeded()
    }
    
//    MARK: Display Message
    func displayMessage(title: String, message: String) {
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = message
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 5
        
        let stackContainer = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackContainer.axis = .vertical
        stackContainer.alignment = .center
        stackContainer.distribution = .fillProportionally
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.alpha = 0
        view.addSubview(stackContainer)
        
        NSLayoutConstraint.activate([stackContainer.topAnchor.constraint(equalTo: invystaLogo.bottomAnchor, constant: 25),
                                     stackContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                                     stackContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
                                     stackContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)])
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.4) {
            stackContainer.alpha = 1
        }
        
    }
    
//   MARK:  Display PointerView
    @objc
    func displayPointerView() {
        
        view.addSubview(pointerView)
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
            self.pointerView.alpha = 1
        }
        
        let size: CGFloat = 100
        NSLayoutConstraint.activate([
            pointerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: -15),
            pointerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            pointerView.widthAnchor.constraint(equalToConstant: size),
            pointerView.heightAnchor.constraint(equalToConstant: size),
        ])
        
        view.layoutIfNeeded()
    }
    
//    MARK: Display Setting Button
    func displaySettingButton() {
        let settingButton = UIButton()
        settingButton.setImage(UIImage(named: "settings"), for: .normal)
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.addTarget(self, action: #selector(moveToSettings), for: .touchUpInside)
        view.addSubview(settingButton)
        
        let padding: CGFloat = 20
        let size: CGFloat = 35
        
        NSLayoutConstraint.activate([
            settingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            settingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            settingButton.heightAnchor.constraint(equalToConstant: size),
            settingButton.widthAnchor.constraint(equalToConstant: size)
        ])
        view.layoutIfNeeded()
    }
    
//    MARK: Display LoadingView
    func displayLoadingView() {
        loadingView = LoadingView(frame: view.frame)
        loadingView?.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.loadingView?.alpha = 1
        }

        view.addSubview(loadingView!)
    }
    
//    MARK: Remove LoadingView
    func removeLoadingView() {
        UIView.animate(withDuration: 0.4) {
            self.loadingView?.alpha = 0
        } completion: { (_) in
            self.loadingView?.removeFromSuperview()
        }
    }
    
//    MARK: Remove Create Debugging Field
    func createDebuggingField(_ text: String) {
        debuggingTextField.text = text
        view.addSubview(debuggingTextField)
        
        NSLayoutConstraint.activate([debuggingTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     debuggingTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     debuggingTextField.heightAnchor.constraint(equalToConstant: 150),
                                     debuggingTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
//    MARK: Successful Request
    @objc
    func successfulRequest() {
        
        removeLoadingView()
        
        if browserData!.action == "reg" {
            displayMessage(title: "Success", message: "Successfuly registered device!")
        } else if browserData!.action == "log" {
            displayPointerView()
            displayMessage(title: "Success", message: "Safely return to your app by clicking on the return button at the top left corner of your screen!")
        }
        
    }
    
    @objc
    func failedRequest() {
        removeLoadingView()
        
        if browserData!.action == "reg" {
            displayMessage(title: "Registration Failed", message: "Failed to register device. Please try again.")
        } else if browserData!.action == "log" {
            displayMessage(title: "Authentication Failed", message: "Failed to authenticate. Please try again.")
        }
        
    }
}