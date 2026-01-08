//
//  CustomFrequencyManager.swift
//  Pods
//
//  Created by yusera-ansari on 02/01/26.
//

import Foundation
class CustomFrequencyManager:SurveyFrequencyManager{
    
    override init(surveyKey: String, showFreq: String, customFreqData: CustomFreqSurveyData?) {
        super.init(surveyKey: surveyKey, showFreq: showFreq, customFreqData: customFreqData)
    }
    private override init(surveyKey: String, showFreq: String) {
        super.init(surveyKey: surveyKey, showFreq: showFreq)
    }
    override func handleFrequency() {
        guard let customFreq else {return}
        let parts = customFreq.freq.split(separator: "-")
        guard parts.count == 2 else {return }
        var obj : [String:Any] = [
            "showFreq": showFreq, // "custom"
                        "freq": customFreq.freq,
                        "startOn": customFreq.startOn,
                        "endOn": customFreq.endOn
        ]
        if parts[1] == "d" {
            obj["lastShownOn"] = DateFormatter.yyyyMMdd.string(from: Date())
        }
        else {
            obj["lastShownOnMillis"] = Date().timeIntervalSince1970 * 1000
        }
        aliumDefaults.setJSON(surveyKey, obj)
    }
    
    override func shouldSurveyLoad() throws -> Bool {
        guard let customFreq else {return true}
        guard isValidFrequency(customFreq.freq) else {
            throw FrequencyError.inavlidCustomFrequencyTypeException("Invalid custom frequency: \(customFreq.freq)")
            
        }
        let parts = customFreq.freq.split(separator: "-")
               let unit = parts[1]

               if unit == "min" || unit == "hrs" {
                   return handleTimeBased()
               } else {
                   return handleDayBased()
               }
    }
    
}

private extension CustomFrequencyManager {

    func isValidFrequency(_ freq: String) -> Bool {
        freq.range(of: #"^\d+-(min|hrs|d)$"#, options: .regularExpression) != nil
    }

    func handleTimeBased() -> Bool {
        guard let stored = aliumDefaults.json(surveyKey),
              let last = stored["lastShownOnMillis"] as? Double else {
            return true
        }

        let interval = intervalMillis()
        return Date().timeIntervalSince1970 * 1000 - last >= interval
    }

    func handleDayBased() -> Bool {
        guard let stored = aliumDefaults.json(surveyKey),
              let last = stored["lastShownOn"] as? String,
              let lastDate = DateFormatter.yyyyMMdd.date(from: last) else {
            return true
        }

        let days = Int(customFreq!.freq.split(separator: "-")[0]) ?? 0
        let next = Calendar.current.date(byAdding: .day, value: days, to: lastDate)!
        return Date() >= next
    }

    func intervalMillis() -> Double {
        let parts = customFreq!.freq.split(separator: "-")
        let value = Double(parts[0]) ?? 0
        return parts[1] == "min" ? value * 60_000 : value * 3_600_000
    }
}

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = .current
        return f
    }()
}
