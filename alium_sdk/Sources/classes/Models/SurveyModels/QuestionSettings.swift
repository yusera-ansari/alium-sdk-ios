//
//  QuestionSettings.swift
//  Pods
//
//  Created by Abcom on 17/12/25.
//

import Foundation

public struct QuestionSetting: Codable, CustomStringConvertible {

    public var required: Bool = true
//    public var ratingType: String = "star"
    public var otherOption: Bool = false
    enum CodingKeys: String, CodingKey {
            case required = "req"
            case otherOption = "oo"
//            case ratingType
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
