//
//  BaseViewController.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/13/20.
//

import UIKit
import Lottie
import InvystaCore

class BaseViewController: UIViewController {
    
    var browserData: ProviderModel?
    
    let coreDataManager: PersistenceManager = PersistenceManager.shared
    
    let invystaLogo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
        
    var pointerView: AnimationView = {
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
    
//    MARK: Display Message
    func displayInvystaLogo() {
        view.addSubview(invystaLogo)
        NSLayoutConstraint.activate([
            invystaLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            invystaLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            invystaLogo.widthAnchor.constraint(equalToConstant: view.frame.width * 0.70),
            invystaLogo.heightAnchor.constraint(equalToConstant: view.frame.width * 0.39)
        ])
        
        view.layoutIfNeeded()
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

//    MARK: Remove uneeded elements
    func removeUneededElements() {
        pointerView.removeFromSuperview()
    }
}
