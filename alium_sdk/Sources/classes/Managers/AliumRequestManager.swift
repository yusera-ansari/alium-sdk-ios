//
//  AliumRequestManager.swift
//  alium_sdk
//
//  Created by yusera-ansari on 09/12/25.
//
import Foundation
@MainActor
class AliumRequestManager{
    static let shared = AliumRequestManager()
    private var isRequestExecuting:Bool = false;
    
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
                shared.stop(screen)
            case .trigger(parameters: let parameters):
                shared.handleNext( parameters)
        }
        
        shared.isRequestExecuting = false;
        execNextRequest(&queue);
        
    }
    
    private func handleNext(_ params:SurveyParameters){
        AliumSurveyLoader(parameters: params).showSurvey()
    }
    
    private func stop(_ screen:String){
        
    }
}
