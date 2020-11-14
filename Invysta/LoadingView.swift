//
//  LoadingView.swift
//  Invysta
//
//  Created by Cyril Garcia on 11/13/20.
//

import UIKit
import Lottie

 class LoadingView: UIView {
    
    let containerView = UIView()
        
    let loadingView: AnimationView = {
        let view = AnimationView()
        view.animation = Animation.named("loading")
        view.animationSpeed = 1.5
        view.loopMode = .loop
        view.play()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.text = "Processing"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {

        backgroundColor = UIColor.white.withAlphaComponent(0.35)
        
        containerView.layer.shadowColor = UIColor.systemGray.cgColor
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOpacity = 0.75
        containerView.layer.cornerRadius = 20
        
        if #available(iOS 13.0, *) {
            containerView.backgroundColor = .systemBackground
        } else {
            containerView.backgroundColor = .white
        }
        
        containerView.addSubview(loadingView)
        containerView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([loadingView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -15),
                                     loadingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: -25),
                                     loadingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 25),
                                     loadingView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: 25),
                                     descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
                                     descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                                     descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
                                     descriptionLabel.heightAnchor.constraint(equalToConstant: 25)])
        
        containerView.layoutIfNeeded()
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 125),
            containerView.heightAnchor.constraint(equalToConstant: 125)
        ])
        
        layoutIfNeeded()
    }
    
}
