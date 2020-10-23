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
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
   
      return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        guard let components = URLComponents(string: url.absoluteString)?.queryItems else { return false }
        
        var data = [String: String]()
        
        for component in components {
            data[component.name] = component.value
        }
        
        let mockBrowserData = BrowserData(email: data["email"] ?? "na-email",
                                          gateKeeper: "https://invystasafe.com/",
                                          fileName: data["pass"] ?? "na-pass",
                                          action: data["action"] ?? "na-action",
                                          oneTimeCode: data["otc"] ?? "na-otc")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        launchViewController(mockBrowserData)
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13, *) { return true }

        window = UIWindow(frame: UIScreen.main.bounds)
        launchViewController()
        
        return true
    }

    func launchViewController(_ browserData: BrowserData? = nil) {
        let vc: ViewController = (browserData == nil) ? ViewController() : ViewController(browserData!)
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
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

