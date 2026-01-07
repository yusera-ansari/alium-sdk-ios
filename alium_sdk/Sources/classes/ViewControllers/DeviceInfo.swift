//
//  DeviceInfo.swift
//  Pods
//
//  Created by yusera-ansari on 05/01/26.
//

import UIKit

enum DeviceType: String {
    case phone = "phone"
    case tablet = "tablet"
    case watch = "watch"
    case unknown = "unknown"
}

final class DeviceInfo {

    private init() {}

    // MARK: - Public API

    static func getUserAgent() -> String {
        let device = UIDevice.current

        let deviceName = device.model
        let osVersion = "\(device.systemName) \(device.systemVersion)"
        let deviceType = getDeviceType().rawValue
        let appId = getAppIdentifier()

        let userAgent = "iOS|\(deviceName)|\(appId)|\(osVersion)|\(deviceType)"
        print("UA:", userAgent)

        return userAgent
    }

    // MARK: - Helpers

    private static func getAppIdentifier() -> String {
        let bundle = Bundle.main

        let appName = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "UNKNOWN"
        let versionName = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
        let versionCode = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"

        return "\(appName) \(versionName) \(versionCode)"
    }

    private static func getDeviceType() -> DeviceType {
        #if os(watchOS)
        return .watch
        #else
       
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .tablet
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            return .phone
        } else {
            return .unknown
        }
        #endif
    }

    /// Matches Android diagonal-inch logic
    private static func isSmallTablet() -> Bool {
        guard let screen = UIScreen.main.currentMode else { return false }

        let size = screen.size
        let scale = UIScreen.main.scale

        let widthInches = CGFloat(size.width) / (scale * 163)
        let heightInches = CGFloat(size.height) / (scale * 163)

        let diagonalInches = sqrt(
            pow(widthInches, 2) + pow(heightInches, 2)
        )

        let maxMobileInches: CGFloat = 7.0
        return diagonalInches <= maxMobileInches
    }
}
