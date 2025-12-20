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
    public var aiSettings: AiSettings?
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

    public var description: String {
        """
        Question(
            id: \(id ?? 0),
            question: "\(question ?? "")",
            responseType: "\(responseType ?? "")",
            responseOptions: \(responseOptions),
            questionSetting: \(questionSetting?.description ?? "nil"),
            aiSettings: \(aiSettings?.description ?? "nil"),
            conditionMapping: \(conditionMapping ?? [])
        )
        """
    }
}
