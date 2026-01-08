//
//  FrequencyManagerFactory.swift
//  Pods
//
//  Created by yusera-ansari on 02/01/26.
//

@MainActor
enum FrequencyError:Error{
    case invalidFrequency(String)
    case invalidCustomFrequencyData
    case inavlidCustomFrequencyTypeException(String)
}

@MainActor
final class FrequencyManagerFactory{
     static func getFrequencyManager( key: String,
                                    srvShowFreq: String,
                                    customFreqSurveyData: CustomFreqSurveyData?)
    throws -> SurveyFrequencyManager
    {
        if srvShowFreq.range(of:#"^\d+$"# , options:.regularExpression) != nil {
            return IntegerFrequencyManager(surveyKey: key, showFreq: srvShowFreq)
        }
        if srvShowFreq == "custom" {
            guard let customFreqSurveyData else{
                throw FrequencyError.invalidCustomFrequencyData
            }
            return CustomFrequencyManager(surveyKey: key, showFreq: srvShowFreq, customFreqData: customFreqSurveyData)
        }
        
        if ["o","rp","os"].contains(srvShowFreq) {
            return BasicFrequencyManager(surveyKey: key, showFreq: srvShowFreq)
        }
        throw FrequencyError.invalidFrequency(srvShowFreq)
    }
}
