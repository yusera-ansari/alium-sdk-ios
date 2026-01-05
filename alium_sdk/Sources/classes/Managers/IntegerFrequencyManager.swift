//
//  IntegerFrequencyManager.swift
//  Pods
//
//  Created by yusera-ansari on 02/01/26.
//


class IntegerFrequencyManager:SurveyFrequencyManager{
    override func handleFrequency() {
        guard let freq = Int(showFreq) else {return}
        var obj:[String:Any] = [
            "showFreq":freq,
            "counter":1
        ]
        
        if
            let stored = aliumDefaults.json(surveyKey),
            let storedFreq = stored["showFreq"] as? Int,
            let counter = stored["counter"] as? Int
        {
            if storedFreq == freq {
                obj["counter"] = counter + 1
            }
        }
        aliumDefaults.setJSON(surveyKey, obj)
        
    }
    
    override func shouldSurveyLoad() throws -> Bool {
        guard
            let freq = Int(showFreq),
            let stored = aliumDefaults.json(showFreq),
            let storedFreq = stored["showFreq"] as? Int,
            let counter = stored["counter"] as? Int
        else {
            return true;
            }
        return !(counter>=freq && storedFreq == freq)
              
    }
}
