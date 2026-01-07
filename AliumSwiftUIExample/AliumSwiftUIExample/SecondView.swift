//
//  SecondView.swift
//  AliumSwiftUIExample
//
//  Created by Abcom on 06/01/26.
//
import SwiftUI
import alium_sdk
struct SecondView:View{
    var body:some View{
        VStack{
            Text("Second View")
        }.onAppear{
            print("second view appeared")
//            Alium.trigger(parameters: SurveyParameters(screenName: "screen3"))
        }
      
        .onDisappear{
            print("second view disappearing ")
//            Alium.stop(on: "screen3")
        }
        
    }
}
