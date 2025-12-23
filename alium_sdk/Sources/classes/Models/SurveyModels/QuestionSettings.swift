//
//  QuestionSettings.swift
//  Pods
//
//  Created by Abcom on 17/12/25.
//

import Foundation

public struct QuestionSetting: Codable, CustomStringConvertible {

    public var required: Bool = false
    public var ratingType: String = "stars"
    public var otherOption: Bool = false
    enum CodingKeys: String, CodingKey {
            case required = "req"
            case otherOption = "oo"
            case ratingType = "rtp"
        }
    public init() { }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            // Decode safely with defaults
            self.required = try container.decodeIfPresent(Bool.self, forKey: .required) ?? false
            self.otherOption = try container.decodeIfPresent(Bool.self, forKey: .otherOption) ?? false
            self.ratingType = try container.decodeIfPresent(String.self, forKey: .ratingType) ?? RatingStyle.tick.rawValue
        }

    public var description: String {
        """
        QuestionSetting(
            required: \(required),
            otherOption: \(otherOption)
        )
        """
        //            ratingType: "\(ratingType)",
    }
}
