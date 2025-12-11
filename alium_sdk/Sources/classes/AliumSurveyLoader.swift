//
//  AliumSurveyLoader.swift
//  alium_sdk
//
//  Created by yusera-ansari on 09/12/25.
//
import UIKit
import Foundation
class AliumSurveyLoader{
    let parameters:SurveyParameters
    init(parameters: SurveyParameters) {
        self.parameters = parameters
    }
    func showSurvey(){
        NSLog("Show Survey is running....")
        guard let window = UIApplication.shared.aliumKeyWindow else {
            print("MyLibrary: No key window found yet")
            return
        }
        let badge = UILabel(frame: CGRect(x: 20, y: 100, width: 300, height: 70))
        
        badge.text = "screen: \(parameters.screenName)"
        badge.font = .boldSystemFont(ofSize: 20)
        badge.textColor = .white
        badge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.92)
        badge.textAlignment = .center
        badge.layer.cornerRadius = 16
        badge.clipsToBounds = true
        badge.alpha = 0
        badge.tag = 999_999 // so we can remove old ones
        
        // Remove any previous badge
        window.viewWithTag(999_999)?.removeFromSuperview()
        
        window.addSubview(badge)
        
        UIView.animate(withDuration: 0.4, animations: {
            badge.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                UIView.animate(withDuration: 0.6) {
                    badge.alpha = 0
                } completion: { _ in
                    badge.removeFromSuperview()
                }
            }
        }
    }
}
