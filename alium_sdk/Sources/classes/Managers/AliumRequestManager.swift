//
//  AliumRequestManager.swift
//  alium_sdk
//
//  Created by yusera-ansari on 09/12/25.
//
@MainActor
class AliumRequestManager{
    static let shared = AliumRequestManager()
    private var isRequestExecuting:Bool = false;
    static func execNextRequest(_ queue: inout [AliumRequest]){
//        handle edge cases
        if(shared.isRequestExecuting || queue.isEmpty){
            if(queue.isEmpty){
                shared.isRequestExecuting = false;
                return;
            }
            return;
        }
        shared.isRequestExecuting = true;
        var request = queue.removeFirst()
        //handle request here
        
        
        shared.isRequestExecuting = false;
        execNextRequest(&queue);
        
    }
}
