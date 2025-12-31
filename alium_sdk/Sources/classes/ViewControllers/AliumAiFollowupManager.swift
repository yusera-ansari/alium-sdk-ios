//
//  AliumAiFollowupManager.swift
//  Pods
//
//  Created by yusera-ansari on 30/12/25.
//

import Foundation

final class AliumAiFollowupManager{
    private(set) var followupIndex:Int = -1;
    private let url = "https://api.aliumsurvey.com/api/v1/public/surveys/ai-followup"
    private var followupHistoryList : [FollowupHistory] = []
    private var currentQuestion:Question? = nil
    var delegate:FollowupDelegate? = nil
    private(set) var aiFollowup: AiFollowup? = nil {
        didSet{
         
        }
    }
    func updateAiFollowup(resp:String){
        print("update ai followup func called: \(resp)")
        aiFollowup?.response = resp
    }
    var isAiFollowupEnabled : Bool {
        guard let currQuest = currentQuestion else{return false}
        if currQuest.aiSettings.enabled && aiFollowup != nil {
            return true
        }
        return false
    }
    private let repository = ""
    private let survey : Survey
    init(survey: Survey ) {
//        self.showAiFollowup = showAiFollowup
        self.survey = survey
    }
    
    func storePreviousFollowUp(){
        print("store previous followup history...\(self.followupIndex)")
        guard self.followupIndex > -1 , let aiFollowup else {
            self.aiFollowup?.response = ""
            print("updated value...\(self.aiFollowup?.response)")
            return}
        let history = FollowupHistory(aiQuestion: aiFollowup.followupQuestion, userAnswer: aiFollowup.response)
        followupHistoryList.append(history)
        self.aiFollowup?.response = ""
        print("updated value...\(self.aiFollowup?.response)")
    }
    
    func incrementFollowupIndex(){
        self.followupIndex += 1
        print("increased index: \(followupIndex)")
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
        currentQuestion = survey.questions?[currentIndex]
        guard let currentQuestion  else{
            return
        }
        
        
        var data:[String : Any] = [
            "survey_id":survey.surveyInfo.surveyId,
            "org_id":survey.surveyInfo.orgId,
            "question_id": currentQuestion.id,
            "question_text":currentQuestion.question,
            "original_response":originalResponse,
            "conversation_history": followupHistoryList.map({ FollowupHistory
                in
                FollowupHistory.toDictionary()
            })
            ,
            "survey_context":[],
            "current_followup_count": followupIndex,
            "max_followups": maxFollowups,
        ]
        print(data)
        self.aiFollowup = nil //for resetting
        CustomNetworkService.getFollowUpQuestion(url: url, params: data) { result in
            switch result{
            case .success(let response):
                print(response)
               
                DispatchQueue.main.async {
                    self.aiFollowup = response
                    print("calling show followup...")
                    self.delegate?.showFollowup(response)
                    completion(.success(response))
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async{
                    completion(.failure(error))
                }
            }
        }
        
    }
    
    
}
