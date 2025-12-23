//
//  AliumTracker.swift
//  Pods
//
//  Created by yusera-ansari on 23/12/25.
//

enum AliumTracker {
    static func track(parameters: [String: Any]) {
        guard !parameters.isEmpty else { return }

        CustomNetworkService.postTrackRequest(
            "https://demo.dwao.in/tracker",
            parameters
        )
    }
}
