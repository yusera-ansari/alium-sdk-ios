//
//  AliumAiFollowupManager.swift
//  Pods
//
//  Created by yusera-ansari on 30/12/25.
//

import Foundation

final class AliumAiFollowupManager{
    private var followupIndex:Int = -1;
    private let url = "https://api.aliumsurvey.com/api/v1/public/surveys/ai-followup"
    private var followupHistoryList : [FollowupHistory] = []
    private var aiFollowup : AiFollowup? = nil
    
    private let repository = ""
    private let survey : Survey
    init(survey: Survey) {
       
        self.survey = survey
    }
    
    func storePreviousFollowUp(){
        guard self.followupIndex > -1 , let aiFollowup else {return}
        let history = FollowupHistory(aiQuestion: aiFollowup.followupQuestion, userAnswer: aiFollowup.response)
        followupHistoryList.append(history)
    }
    
    func incrementFollowupIndex(){
        self.followupIndex += 1
    }
    func shouldStop(freq:Int)->Bool{
        incrementFollowupIndex()
        if followupIndex >= freq || (aiFollowup != nil && aiFollowup?.shouldFollowup == false){
            
            aiFollowup = nil
            followupIndex = -1
            followupHistoryList.removeAll()
            return true
        }
        return false
    }
    
    func getFollowupQuestion(
        maxFollowups: Int,
              currentIndex: Int,
              originalResponse: String,
              completion: @escaping (Result<AiFollowup, Error>)->Void
    ){
        
        guard let currentQuestion = survey.questions?[currentIndex] else{
            return
        }
        
        var data:[String : Any] = [
            "survey_id":survey.surveyInfo.surveyId,
            "org_id":survey.surveyInfo.orgId,
            "question_id": currentQuestion.id,
            "question_text":currentQuestion.question,
            "original_response":originalResponse,
            "conversation_histort": followupHistoryList.map({ FollowupHistory
                in
                FollowupHistory.toDictionary()
            })
            ,
            "survey_context":[],
            "current_followup_count": followupIndex,
            "max_followups": maxFollowups,
            
        ]
        
        CustomNetworkService.getFollowUpQuestion(url: url, params: data) { result in
            switch result{
            case .success(let response):
                print(response)
                self.aiFollowup = response
                completion(.success(response))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
        
    }
    
    
}
