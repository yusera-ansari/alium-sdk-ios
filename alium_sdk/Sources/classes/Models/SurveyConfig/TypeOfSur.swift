//
//  TypeOfSur.swift
//  alium_sdk
//
//  Created by yusera-ansari on 09/12/25.
//

import Foundation

public struct TypeOfSur: Codable {
    public var app: App?
    public enum CodingKeys : String, CodingKey{
        case app = "ap"
    }
}
