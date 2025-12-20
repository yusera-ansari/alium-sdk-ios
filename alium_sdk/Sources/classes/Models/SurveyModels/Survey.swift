//
//  Survey.swift
//  Pods
//
//  Created by yusera-ansari on 17/12/25.
//

import Foundation

public struct Survey: Codable, CustomStringConvertible {

    public var questions: [Question]?
    public var surveyInfo: SurveyInfo = SurveyInfo()
    enum CodingKeys: String, CodingKey {
         case questions = "sq"
         case surveyInfo = "si"
     }
    public var description: String {
        """
        Survey(
            questions: \(questions ?? []),
            surveyInfo: \(surveyInfo)
        )
        """
    }


}
