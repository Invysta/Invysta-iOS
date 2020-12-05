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
    var stackContainer: UIStackView?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        label.numberOfLines = 2
        return label
    }()
    
    let descriptionLabel: UITextView = {
        let label = UITextView()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
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
    
    private var pointerView: AnimationView = {
        let view = AnimationView()
        view.animation = Animation.named("pointer-black")
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
        preparePointerAnimation()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        preparePointerAnimation()
    }
    
    func preparePointerAnimation() {
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                pointerView.animation = Animation.named("pointer-white")
            } else {
                pointerView.animation = Animation.named("pointer-black")
            }
            pointerView.animationSpeed = 2
            pointerView.loopMode = .loop
            pointerView.play()
        }
    }
        
//    MARK: Move to settings
    @objc
    func moveToSettings() {
        let vc = SettingsController()
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        present(nav, animated: true, completion: nil)
    }
    
//    MARK: Display Message
    func displayInvystaLogo() {
        view.addSubview(invystaLogo)
//        print(view.frame.width, 250.0, 250.0 / view.frame.width)
        NSLayoutConstraint.activate([
            invystaLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            invystaLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            invystaLogo.widthAnchor.constraint(equalToConstant: view.frame.width * 0.70),
            invystaLogo.heightAnchor.constraint(equalToConstant: view.frame.width * 0.39)
        ])
        
        view.layoutIfNeeded()
    }
    
//    MARK: Display Message
    func displayMessage(title: String, message: String) {
        
        titleLabel.text = title
        descriptionLabel.text = message
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: invystaLogo.bottomAnchor, constant: 25),
                                     titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                                     titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
                                     titleLabel.heightAnchor.constraint(equalToConstant: 40),
                                     
                                     descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
                                     descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                                     descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
                                     descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)])
        
        view.layoutIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.titleLabel.alpha = 1
                self?.descriptionLabel.alpha = 1
                self?.removeLoadingView()
            }
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
        let size: CGFloat = 30
        
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
    
    func response(with title: String, and message: String,_ showPointer: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            if showPointer {
                self?.displayPointerView()
            }
            self?.displayMessage(title: title, message: message)
            self?.removeLoadingView()
        }
    }

//    MARK: Remove uneeded elements
    func removeUneededElements() {
        titleLabel.removeFromSuperview()
        descriptionLabel.removeFromSuperview()
        pointerView.removeFromSuperview()
    }
}
