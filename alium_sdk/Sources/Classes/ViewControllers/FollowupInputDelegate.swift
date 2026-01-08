//
//  FollowupInputDelegate.swift
//  Pods
//
//  Created by yusera-ansari on 31/12/25.
//
@MainActor
protocol FollowupInputDelegate:AnyObject {
    func onFollowupResponse(resp:String)
}
