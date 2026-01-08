//
//  AliumRequestManager.swift
//  alium_sdk
//
//  Created by yusera-ansari on 09/12/25.
//
import Foundation
@MainActor
final class AliumRequestManager: @preconcurrency SurveyStateDelegate{
    
    func onClose(_ surveyKey: String) {
    
        AliumRequestManager.executingKeys.removeAll(where: {
            if  $0.parameters.screenName == surveyKey {
                print("will remove \(surveyKey) from list")
            }
          return  $0.parameters.screenName == surveyKey
        })
        }
    
    
    static let shared = AliumRequestManager()
    private var isRequestExecuting:Bool = false;
    static var executingKeys : [AliumSurveyLoader] = []
    
    public static func execNextRequest(_ queue: inout [AliumRequest]){
    NSLog("Executing next request...")
//        handle edge cases
        if(shared.isRequestExecuting || queue.isEmpty){
            if(queue.isEmpty){
                NSLog("Request queue is empty!")
                shared.isRequestExecuting = false;
                return;
            }
            NSLog("Another request in execution...can't proceed with current req.")
            return;
        }
        shared.isRequestExecuting = true;
        var request = queue.removeFirst()
        //handle request here
        switch request.type{
            case .stop(screen: let screen):
            print("request to stop a screen \(screen)")
                shared.stop(screen)
            case .trigger(parameters: let parameters):
                shared.handleNext( parameters)
        }
        
        shared.isRequestExecuting = false;
        execNextRequest(&queue);
        
    }
    
    private func handleNext(_ params:SurveyParameters){
        
        for loader in AliumRequestManager.executingKeys {
            if loader.parameters.screenName == params.screenName {
                print("survey with key \(params.screenName) already running!, ignoring this request")
                return;
            }
        }
        if Alium.shared.appType == .SwiftUI {
//            remove existing view controller of Alium if any
            if let topVC = ViewControllerFinder.topViewController() {
                if topVC is OverlayViewController {
                    topVC.dismiss(animated: false)
                }
            }
        }
        let loader =  AliumSurveyLoader(parameters: params, delegate: self)
        AliumRequestManager.executingKeys.append(loader)
        loader.showSurvey()
    
    }
    
    private func stop(_ key:String){
        print("survey stop: \(key)")
//        for loader in AliumRequestManager.executingKeys {
//            print("finding keys: current key: \(loader.parameters.screenName)")
//            if loader.parameters.screenName == key {
////                implementation pending
//                loader.stop()
//                
//                print("stopping survey with key \(key) already running!")
//                return;
//                
//            }
//        }
        AliumRequestManager.executingKeys.removeAll(where: {
            if  $0.parameters.screenName == key {
                $0.stop()
                print("stopping survey with key \($0.parameters.screenName) \(key) already running!")
                return true
            }
            return false
        })
    }
}
