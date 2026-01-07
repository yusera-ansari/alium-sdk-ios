//
//  ContentView.swift
//  AliumSwiftUIExample
//
//  Created by yusera-ansari on 08/12/25.
//

import SwiftUI
import alium_sdk
struct ContentView: View {
    @State var navigate = false
    var body: some View {
        NavigationStack{
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
               
            }
            NavigationLink(destination: SecondView(), isActive: $navigate){
                Text("Navigate")
            }
            .padding()
            .onAppear{
                Alium.trigger(parameters: SurveyParameters(screenName: "screen2"))
                DispatchQueue.main.asyncAfter(deadline: .now()+5, execute:{
                    navigate = true
                })
            }
            .onDisappear{
                print("content view disappearing ")
                Alium.stop(on: "screen2")
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
