//
//  Question.swift
//  Pods
//
//  Created by yusera-ansari on 17/12/25.
//

import Foundation

public struct Question: Codable, CustomStringConvertible {

    public var id: Int?
    public var question: String?
    public var responseType: String?
    public var responseOptions: [String] = []

    public var questionSetting: QuestionSetting?
    public var aiSettings: AiSettings = AiSettings()
    public var conditionMapping: [String]?
    enum CodingKeys: String, CodingKey {
        case id
        case question = "qs"
        case responseType = "rt"
        case responseOptions = "ro"
        case questionSetting = "st"
        case conditionMapping = "cm"
        case aiSettings = "ai"
    }
    
    // Custom decoding
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            id = try container.decodeIfPresent(Int.self, forKey: .id)
            question = try container.decodeIfPresent(String.self, forKey: .question)
            responseType = try container.decodeIfPresent(String.self, forKey: .responseType)
            questionSetting = try container.decodeIfPresent(QuestionSetting.self, forKey: .questionSetting)
            aiSettings = try container.decodeIfPresent(AiSettings.self, forKey: .aiSettings) ?? AiSettings()
            conditionMapping = try container.decodeIfPresent([String].self, forKey: .conditionMapping)

            // Handle [String] OR [Int]
            if let stringOptions = try? container.decode([String].self, forKey: .responseOptions) {
                responseOptions = stringOptions
            } else if let intOptions = try? container.decode([Int].self, forKey: .responseOptions) {
                responseOptions = intOptions.map(String.init)
            } else {
                responseOptions = []
            }
        }

        // Required because we added custom init
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(id, forKey: .id)
            try container.encodeIfPresent(question, forKey: .question)
            try container.encodeIfPresent(responseType, forKey: .responseType)
            try container.encode(responseOptions, forKey: .responseOptions)
            try container.encodeIfPresent(questionSetting, forKey: .questionSetting)
            try container.encodeIfPresent(aiSettings, forKey: .aiSettings)
            try container.encodeIfPresent(conditionMapping, forKey: .conditionMapping)
        }

    public var description: String {
        """
        Question(
            id: \(id ?? 0),
            question: "\(question ?? "")",
            responseType: "\(responseType ?? "")",
            responseOptions: \(responseOptions),
            questionSetting: \(questionSetting?.description ?? "nil"),
            aiSettings: \(aiSettings.description ),
            conditionMapping: \(conditionMapping ?? [])
        )
        """
    }
}
