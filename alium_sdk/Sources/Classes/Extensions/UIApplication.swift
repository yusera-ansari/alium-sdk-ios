//
//  UIApplication.swift
//  Pods
//
//  Created by yusera-ansari on 11/12/25.
//
import Foundation
import UIKit
extension UIApplication{
    var aliumKeyWindow:UIWindow?{
        if #available(iOS 13.0, *) {
            return self.connectedScenes
                .compactMap{$0 as? UIWindowScene}
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        }else{
            return keyWindow
        }
    }
}
