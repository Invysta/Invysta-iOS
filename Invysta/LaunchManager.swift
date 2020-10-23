//
//  LaunchManager.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/23/20.
//

import UIKit

final class LaunchManager {
    
    static func launchViewController(_ browserData: BrowserData) {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ViewController(browserData)
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    @available(iOS 13.0, *)
    static func launchViewController(_ browserData: BrowserData,_ windowScene: UIWindowScene) {
        
        let vc = ViewController(browserData)
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.rootViewController = vc
        window.windowScene = windowScene
        window.makeKeyAndVisible()
    }
}
