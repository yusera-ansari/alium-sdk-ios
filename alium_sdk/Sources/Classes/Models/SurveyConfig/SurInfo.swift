//
//  SurInfo.swift
//  alium_sdk
//
//  Created by yusera-ansari on 09/12/25.
//

import Foundation

struct SurInfo: Codable {
    var id: Int?
    var nm: String?
    
    var tps: TypeOfSur?
    public enum CodingKeys : String, CodingKey{
        case id, nm, tps
     }
}
