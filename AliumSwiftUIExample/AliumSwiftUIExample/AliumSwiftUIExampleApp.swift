//
//  AliumSwiftUIExampleApp.swift
//  AliumSwiftUIExample
//
//  Created by yusera-ansari on 08/12/25.
//

import SwiftUI
import alium_sdk


class AppDelegate :NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Alium.config(key: "")
        Alium.setAppType(.SwiftUI)
        
        return true
    }
}
@main
struct AliumSwiftUIExampleApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .onAppear(perform: {
                  
                })
        }
    }
}
