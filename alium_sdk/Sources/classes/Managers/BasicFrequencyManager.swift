//
//  BasicFrequencyManager.swift
//  Pods
//
//  Created by Abcom on 02/01/26.
//

final class BasicFrequencyManager: SurveyFrequencyManager {
   

    override func handleFrequency() {
        if showFreq == "rp" { return }
        print("updating basic frequency for: \(showFreq)")
        aliumDefaults.set(for: surveyKey, showFreq)
    }
    
    override func shouldSurveyLoad() -> Bool {
        let stored = aliumDefaults.get(surveyKey)
        guard !stored.isEmpty else { return true } //nothing was stored - case rp

        if stored != showFreq { //frequnecy changed
            aliumDefaults.remove(surveyKey)
            return true
        }
        return false
    }
}

