//
//  FollowupHistory.swift
//  Pods
//
//  Created by yusera-ansari on 30/12/25.
//

struct FollowupHistory:Codable {
    let aiQuestion : String
    let userAnswer : String
    init(aiQuestion: String, userAnswer: String) {
        self.aiQuestion = aiQuestion
        self.userAnswer = userAnswer
    }
    enum CodingKeys : String, CodingKey{
        case aiQuestion = "ai_question"
        case userAnswer = "user_answer"
    }
    func toDictionary ()->[String:String]{
        return [
            "ai_question": aiQuestion,
            "user_answer": userAnswer
        ]
    }
}
