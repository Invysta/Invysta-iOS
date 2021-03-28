//
//  SceneDelegate.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit
import Invysta_Framework

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var vc: ViewController?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
    
        if let url = URLContexts.first?.url {
            let browserData = process(url)
            launchViewController(windowScene, browserData)
        } else {
            launchViewController(windowScene)
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        IdentifierManager.configure([AccessibilityIdentifier(),
                                     CellularIdentifier(),
                                     CustomIdentifier(),
                                     DeviceCheckIdentifier(),
                                     DeviceModelIdentifier(),
                                     FirstTimeInstallationIdentifier(),
                                     VendorIdentifier()])
        
        if let url = connectionOptions.urlContexts.first?.url.absoluteURL {
            let browserData = process(url)
            launchViewController(windowScene,browserData)
        } else {
            launchViewController(windowScene)
        }
     
    }

    func process(_ url: URL) -> InvystaBrowserDataModel? {
        InvystaService.log(.warning, "Passed URL \(url.absoluteString)")
        
        guard let components = URLComponents(string: url.absoluteString)?.queryItems else { return nil }
        var data = [String: String]()
        
        for component in components {
            data[component.name] = component.value
        }
        
        return InvystaBrowserDataModel(action: data["action"]!, uid: data["uid"]!, nonce: data["nonce"]!)

    }
    
    func launchViewController(_ windowScene: UIWindowScene, _ browserData: InvystaBrowserDataModel? = nil) {
        
        let tabBarcontroller = UITabBarController()
        
        vc = (browserData == nil) ? ViewController() : ViewController(browserData!)
        vc?.title = "Home"
        
        let activityController = UINavigationController(rootViewController: ActivityViewController())
        activityController.title = "Activity"
        
        let settingsController = UINavigationController(rootViewController: SettingsController())
        settingsController.title = "Settings"
        
        tabBarcontroller.viewControllers = [vc!, activityController, settingsController]
        tabBarcontroller.tabBar.items?[0].image = UIImage(named: "home")
        tabBarcontroller.tabBar.items?[1].image = UIImage(named: "activity")
        tabBarcontroller.tabBar.items?[2].image = UIImage(named: "settings")
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.rootViewController = tabBarcontroller
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        vc?.removeUneededElements()
    }

}
