//
//  AiSettings.swift
//  Pods
//
//  Created by yusera-ansari on 17/12/25.
//

import Foundation

public struct AiSettings: Codable, CustomStringConvertible {

    public var enabled: Bool = false
    public var maxFrequency: Int = 0
    enum CodingKeys: String, CodingKey {
          case enabled = "en"
          case maxFrequency = "mf"
      }
    public var description: String {
        """
        AiSettings(
            enabled: \(enabled),
            maxFrequency: \(maxFrequency)
        )
        """
    }
}
