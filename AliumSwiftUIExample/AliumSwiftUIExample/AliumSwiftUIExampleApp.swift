//
//  AliumSwiftUIExampleApp.swift
//  AliumSwiftUIExample
//
//  Created by yusera-ansari on 08/12/25.
//

import SwiftUI
import alium_sdk

@main
struct AliumSwiftUIExampleApp: App {
    
    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .onAppear(perform: {
                    ALium.testAlium()
                })
        }
    }
}
