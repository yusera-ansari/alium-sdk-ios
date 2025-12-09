//
//  AliumRequest.swift
//  alium_sdk
//
//  Created by yusera-ansari on 09/12/25.
//

 class AliumRequest{
    let type:RequestType
    enum RequestType{
        case stop(screen:String)
        case trigger( parameters: SurveyParameters)
    }
    init(type: RequestType) {
        self.type = type
    }
}
