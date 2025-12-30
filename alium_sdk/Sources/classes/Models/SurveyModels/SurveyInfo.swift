//
//  SurveyInfo.swift
//  alium_sdk
//
//  Created by yusera-ansari on 09/12/25.
//

public struct SurveyInfo : Codable{
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
    public var orgId: Int?
 
    public var customerId: Int?
    public var surveyId: String?
    public var language: String?
    public var position: String?
 
    public var theme: String?
    public var viewFrequency:String?
    public var type: Int?
    public var themeColors: ThemeColors = ThemeColors()
     public enum CodingKeys:String, CodingKey{
       
        
        case orgId = "oid"
            case customerId = "cid"
            case surveyId = "sid"
            case language = "lng"
            case position = "pos"
            case type = "stp"
            case viewFrequency = "vf"
            case theme = "th"
            case themeColors = "thc"
    }
}

