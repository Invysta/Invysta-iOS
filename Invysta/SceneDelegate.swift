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

    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {

    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        guard let url = URLContexts.first?.url.absoluteString else { return }
        guard let components = URLComponents(string: url)?.queryItems else { return }
        
        var data = [String: String]()
        
        for component in components {
            data[component.name] = component.value
        }
        
        let browserData = BrowserData(action: data["action"],
                                      oneTimeCode: data["otc"],
                                      encData: data["encData"],
                                      magic: data["magic"])
        print("Launching with",browserData.see)
        launchViewController(windowScene,browserData)
        
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        if let mockBrowserData = FeatureFlagBrowserData().check() as? BrowserData {
            launchViewController(windowScene, mockBrowserData)
            return
        }
        launchViewController(windowScene)
    }
    
    func launchViewController(_ windowScene: UIWindowScene, _ browserData: BrowserData? = nil) {
        
        let vc: ViewController = (browserData == nil) ? ViewController() : ViewController(browserData!)
        
        if browserData == nil {
            vc.debuggingTextField.text = "RegLaunch"
        } else {
            vc.debuggingTextField.text = "WithURL"
        }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.rootViewController = vc
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
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}
