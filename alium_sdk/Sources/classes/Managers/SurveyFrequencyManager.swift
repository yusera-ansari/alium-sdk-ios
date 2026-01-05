//
//  SurveyFrequencyManager.swift
//  Pods
//
//  Created by yusera-ansari on 02/01/26.
//

open class SurveyFrequencyManager{
    let aliumDefaults = AliumUserDefaults.shared
    let surveyKey:String
    let showFreq:String
    let customFreq:CustomFreqSurveyData?
    init(surveyKey: String, showFreq: String) {
        self.surveyKey = surveyKey
        self.showFreq = showFreq
        self.customFreq = nil
    }
    init(surveyKey: String, showFreq: String, customFreqData:CustomFreqSurveyData?) {
        self.surveyKey = surveyKey
        self.showFreq = showFreq
        self.customFreq = customFreqData
    }
    open func handleFrequency(){
        fatalError("Subclasses must override handleFrequency()")
    }
    
    /// Wrapper to record survey trigger
        public final func recordSurveyTriggerOnPreferences() {
        
            handleFrequency()
        }

        /// Determine whether the survey should load
        open func shouldSurveyLoad() throws -> Bool {
            fatalError("Subclasses must override shouldSurveyLoad()")
        }
    
}
