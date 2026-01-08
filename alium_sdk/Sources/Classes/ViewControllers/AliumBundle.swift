//
//  AliumBundle.swift
//  Pods
//
//  Created by Abcom on 23/12/25.
//
import Foundation
public class AliumBundle {
    public static func getBundle()->Bundle?{
    #if SWIFT_PACKAGE
    return .module
    #else
    let bundle = Bundle(for: AliumBundle.self)
        guard let bundleUrl =  bundle.url(forResource: "alium_sdk", withExtension: "bundle") else { return nil }
    return Bundle(url: bundleUrl)
    #endif
    }
    
}
