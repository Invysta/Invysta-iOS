//
//  SceneDelegate.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit

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
        
        if let mockBrowserData = FeatureFlagBrowserData().check() as? BrowserData {
            launchViewController(windowScene, mockBrowserData)
            return
        }
        
        if let url = connectionOptions.urlContexts.first?.url.absoluteURL {
            let browserData = process(url)
            launchViewController(windowScene,browserData)
        } else {
//            launchViewController(windowScene)
            firstTimeUser(windowScene)
        }
     
    }
    
    func firstTimeUser(_ windowScene: UIWindowScene) {
        let registerController = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController")
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.rootViewController = registerController
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }
    
    func process(_ url: URL) -> BrowserData? {
        print("PassedURL",url.absoluteString)
        
        guard let components = URLComponents(string: url.absoluteString)?.queryItems else { return nil }
        var data = [String: String]()
        
        for component in components {
            data[component.name] = component.value
        }
        
        return BrowserData(action: data["action"]!, uid: data["uid"]!, nonce: data["nonce"]!)

    }
    
    func launchViewController(_ windowScene: UIWindowScene, _ browserData: BrowserData? = nil) {
        let tabBarcontroller = UITabBarController()
        
        vc = (browserData == nil) ? ViewController() : ViewController(browserData!)
        vc?.title = "Home"
        
        let activityController = GlobalPreferences.makeNavigationController(ActivityViewController())
        activityController.title = "Activity"
        
        let settingsController = GlobalPreferences.makeNavigationController(SettingsController())
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
