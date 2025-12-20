//
//  ViewControllerFinder.swift
//  Pods
//
//  Created by yusera-ansari on 18/12/25.
//

import UIKit
import Foundation

@MainActor
class ViewControllerFinder {
    static func currentWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    static func topViewController(base: UIViewController? = nil
    ) -> UIViewController? {
        let baseVC = base ?? currentWindow()?.rootViewController
        
        if let nav = baseVC as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = baseVC as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        
        if let presented = baseVC?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return baseVC
    }
}
