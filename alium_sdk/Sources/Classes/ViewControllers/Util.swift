//
//  Util.swift
//  Pods
//
//  Created by yusera-ansari on 05/01/26.
//

import UIKit

final class Util {

    private static let offset: UInt64 = 100_000_000

    private init() {}

    // MARK: - Customer ID

    static func generateCustomerId() -> String {
        let currentTime = UInt64(Date().timeIntervalSince1970 * 1000) % offset
        let randomNumber = UInt64.random(in: 0..<offset)
        return String(currentTime + randomNumber)
    }

  
}
