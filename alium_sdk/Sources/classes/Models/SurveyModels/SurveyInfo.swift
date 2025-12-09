//
//  SurveyInfo.swift
//  alium_sdk
//
//  Created by yusera-ansari on 09/12/25.
//

struct SurveyInfo : Codable{
    //          "orgId": "128",
//                  "orgName": "ASDF",
//                  "customerId": null,
//                  "surveyId": "956",
//                  "language": "",
//                  "position": "",
//                  "background": "",
//                  "uniqueidentifier": "",
//                  "elmsltr": "",
//                  "theme": "",
//                  "branding": "",
//                  "type": 1,
//                  "thanksMessage": "",
//                  "vf": "overandover"
       var orgId: Int?
       var orgName: String?
       var customerId: String?
       var surveyId: String?
       var language: String?
       var position: String?
       var background: String?
       var uniqueidentifier: String?
       var theme: String?
       var branding: String?
       var type: String?
       var themeColors: ThemeColors?
    
    enum CodingKeys:String, CodingKey{
        case orgId, orgName, customerId, surveyId, language, position, background
        case uniqueidentifier, theme, branding, type, themeColors
        
        
    }
}

