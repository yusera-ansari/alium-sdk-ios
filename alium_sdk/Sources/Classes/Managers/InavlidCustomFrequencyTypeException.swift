//
//  InavlidCustomFrequencyTypeException.swift
//  Pods
//
//  Created by yusera-ansari on 02/01/26.
//

final class InavlidCustomFrequencyTypeException:Error {
    let message: String
    init(_ message: String) { self.message = message }
}
