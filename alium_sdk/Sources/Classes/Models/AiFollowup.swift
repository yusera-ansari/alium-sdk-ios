//
//  AiFollowup.swift
//  Pods
//
//  Created by yusera-ansari on 30/12/25.
//

struct AiFollowup: Codable, CustomStringConvertible {

    let shouldFollowup: Bool
    let followupQuestion: String
    let remainingFollowups: Int
    var response: String = ""
    enum CodingKeys:String, CodingKey{
        case shouldFollowup = "should_followup"
        case followupQuestion="followup_question"
        case remainingFollowups="remaining_followups"
    }
    var description: String {
        """
        AiFollowup{
            shouldFollowup=\(shouldFollowup),
            followupQuestion='\(followupQuestion)',
            remainingFollowups=\(remainingFollowups),
            response='\(response)'
        }
        """
    }
}
