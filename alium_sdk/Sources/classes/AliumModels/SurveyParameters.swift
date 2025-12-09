//
//  SurveyParameters.swift
//  alium_sdk
//
//  Created by yusera-ansari on 09/12/25.
//

import Foundation

public struct SurveyParameters {
    public let screenName: String
    public let customerVariables: [String: String]

    public init(screenName: String, customerVariables: [String: String] = [:]) {
        self.screenName = screenName
        self.customerVariables = customerVariables
    }
}
