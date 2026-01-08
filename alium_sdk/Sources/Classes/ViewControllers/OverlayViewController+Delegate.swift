//
//  OverlayViewController+Delegate.swift
//  Pods
//
//  Created by yusera-ansari on 23/12/25.
//

extension OverlayViewController : ALiumInputDelegate, FollowupDelegate, FollowupInputDelegate{
   
    
    
    func onFollowupResponse(resp: String) {
        print("followup response: ", resp)
        if self.followupManager.isAiFollowupEnabled && self.followupManager.aiFollowup != nil{
            print("update ai followup response...")
            self.followupManager.updateAiFollowup(resp: resp)
            return;
        }
    }
    
    func showFollowup(_ aiFollowup: AiFollowup) {
        print("process ai followup")
        question.text = aiFollowup.followupQuestion
        responseContainer.emptyView()
        
        input.maxHeight = 120
        input.textView.text = ""
        input.placeholderLabel.isHidden = false
        print("i updated the test::: \(input.textView.text)")
        responseContainer.addSubview(input)
        input.pin(toMarginOf: responseContainer)
        input.setPlaceholder("Enter you response here")
        input.delegate = self
    }
    
    func onResponse(resp: String) {
        print("response: ", resp)
        if self.followupManager.isAiFollowupEnabled && self.followupManager.aiFollowup != nil{
            print("update ai followup response...")
            self.followupManager.updateAiFollowup(resp: resp)
            return;
        }
        
        response = resp
       
        
        
    }
    func enableNext(flag: Bool) {
        print("enable Next: \(flag)")
        enableBtn(nextBtn, flag: (currQuest!.questionSetting.required) ? flag : true    )
//        enableBtn(nextBtn, flag: (currQuest!.questionSetting.required  &&  !resp.isEmpty) ? true : false )
    }
    
    
}
