//
//  FollowupDelegate.swift
//  Pods
//
//  Created by yusera-ansari on 31/12/25.
//
@MainActor
protocol FollowupDelegate:AnyObject {
    func showFollowup(_ aiFollowup:AiFollowup)
}
