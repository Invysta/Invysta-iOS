//
//  GlobalPreferences.swift
//  Invysta
//
//  Created by Cyril Garcia on 12/15/20.
//

import UIKit

final class GlobalPreferences {
    static func makeNavigationController(_ vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController()
        nav.viewControllers = [vc]
        return nav
    }
}
