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
    
    func initUI() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.white
        }
        displaySettingButton()
    }
    
    private let loadingView: AnimationView = {
        let view = AnimationView()
        view.animation = Animation.named("loading")
        view.animationSpeed = 1
        view.loopMode = .loop
        view.play()
        return view
    }()
    
    @objc
    func moveToSettings() {
        let vc = SettingsController()
        let nav = UINavigationController()
        nav.viewControllers = [vc]
        present(nav, animated: true, completion: nil)
    }
    
    @objc
    func displayPointerView() {
        let animationView = AnimationView()
        animationView.animation = Animation.named("pointer-black")
        animationView.animationSpeed = 1.5
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        let size: CGFloat = 100
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: -10),
            animationView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            animationView.widthAnchor.constraint(equalToConstant: size),
            animationView.heightAnchor.constraint(equalToConstant: size),
        ])
        
        UIView.animate(withDuration: 1.5) {
            self.loadingView.alpha = 0
            self.loadingView.stop()
        }
        
        let textLabel = UITextView()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.isScrollEnabled = false
        textLabel.backgroundColor = .clear
        textLabel.font = .preferredFont(forTextStyle: .largeTitle)
        
        if browserData!.action == "reg" {
            textLabel.text = """
                Registration Successful!
                Safely return to your app by clicking at the top left button
                """
        } else if browserData!.action == "log" {
            textLabel.text = """
                Login Successful!
                Safely return to your app by clicking at the top left button
                """
        }
        
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 150),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.layoutIfNeeded()
    }
    
    func displaySettingButton() {
        let settingButton = UIButton()
        settingButton.setImage(UIImage(named: "settings"), for: .normal)
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.addTarget(self, action: #selector(moveToSettings), for: .touchUpInside)
        view.addSubview(settingButton)
        
        let padding: CGFloat = 15
        let size: CGFloat = 25
        
        NSLayoutConstraint.activate([
            settingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            settingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            settingButton.heightAnchor.constraint(equalToConstant: size),
            settingButton.widthAnchor.constraint(equalToConstant: size)
        ])
        view.layoutIfNeeded()
    }
    
    func displayLoadingView() {
        let loadingViewFrame: CGFloat = 200
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([loadingView.heightAnchor.constraint(equalToConstant: loadingViewFrame),
                                     loadingView.widthAnchor.constraint(equalToConstant: loadingViewFrame),
                                     loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        view.layoutIfNeeded()
    }
    
    func createDebuggingField(_ text: String) {
        debuggingTextField.text = text
        view.addSubview(debuggingTextField)
        
        NSLayoutConstraint.activate([debuggingTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     debuggingTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     debuggingTextField.heightAnchor.constraint(equalToConstant: 150),
                                     debuggingTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
}
