//
//  AppDelegate.swift
//  Invysta
//
//  Created by Cyril Garcia on 10/12/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var vc: ViewController?
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        launchViewController(process(url))
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13, *) { return true }

        window = UIWindow(frame: UIScreen.main.bounds)
        launchViewController()
        
        return true
    }

    func process(_ url: URL) -> BrowserData? {
        guard let components = URLComponents(string: url.absoluteString)?.queryItems else { return nil }
        
        var data = [String: String]()
        
        for component in components {
            data[component.name] = component.value
        }
        
        return BrowserData(action: data["action"]!,
                           oneTimeCode: data["otc"],
                           encData: data["encData"]!,
                           magic: data["magic"]!)
    }
    
    func launchViewController(_ browserData: BrowserData? = nil) {
        vc = (browserData == nil) ? ViewController() : ViewController(browserData!)
        
        let activityController = ActivityViewController()
        let navigationController = UINavigationController()
        navigationController.viewControllers = [activityController]
        
        let tabViewController = UITabBarController()
        
        navigationController.title = "Activity"
        vc?.title = "Home"
        tabViewController.viewControllers = [vc!, navigationController]
        
        window?.rootViewController = tabViewController
        window?.makeKeyAndVisible()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        vc?.removeUneededElements()
    }
    
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

