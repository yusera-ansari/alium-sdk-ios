//
//  App.swift
//  alium_sdk
//
//  Created by yusera-ansari on 09/12/25.
//

import Foundation

public struct App: Codable {
   public var um: UrlMatch?
    public var vf: String?
    var spath: String?
    public var customSurveyDetails: CustomSurveyDetails?
    public enum CodingKeys : String, CodingKey{
        case um, vf
        case spath = "spt"
    }
}
