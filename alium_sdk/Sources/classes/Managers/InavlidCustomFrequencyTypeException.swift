//
//  InavlidCustomFrequencyTypeException.swift
//  Pods
//
//  Created by Abcom on 02/01/26.
//

final class InavlidCustomFrequencyTypeException:Error {
    let message: String
    init(_ message: String) { self.message = message }
}
