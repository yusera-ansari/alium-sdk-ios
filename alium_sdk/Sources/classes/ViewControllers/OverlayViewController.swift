//
//  OverlayViewController.swift
//  Pods
//
//  Created by yusera-ansari on 15/12/25.
//

import UIKit
import SwiftUI


import UIKit
import Foundation
class OverlayViewController: UIViewController {
    let uuid = UUID().uuidString
    let input = MultilineTextInput()
    let followupManager:AliumAiFollowupManager!
    var response:String=""
    var currQuest:Question?
    let survey: Survey
    let parameters:SurveyParameters
    var index:Int = 0{
        didSet{
          
        }
    };
    let viewFrequency:String
    var frequencyManager:SurveyFrequencyManager? = nil
    var responseSubmitIndex = 1;
    lazy var container : UIView = {
        var v : UIView = UIView()
        v.backgroundColor = .lightGray
       let color = survey.surveyInfo.themeColors.color1
            v.backgroundColor = .init(hexString: color )
        
        v.layer.cornerRadius = 10
        return v;
    }()
    lazy var responseContainer:UIView = {
        var l = UIView()
        
        return l
    }()
    lazy var question:UILabel = {
        let l = UILabel()
        let color = survey.surveyInfo.themeColors.color2
            l.textColor = .init(hexString:color )
        
        l.textAlignment = .center
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.setContentCompressionResistancePriority(.required, for: .vertical)
           l.setContentHuggingPriority(.required, for: .vertical)
        return l
    }()
    private var nextBtnCenterX: NSLayoutConstraint!
    private var nextBtnTrailing: NSLayoutConstraint!
    private var nextBtnWidth: NSLayoutConstraint!
    lazy var nextBtn:UIButton = {
       var b = UIButton()
         let backgroundColor = survey.surveyInfo.themeColors.color3
        let textColor = survey.surveyInfo.themeColors.color4
            b.backgroundColor = .init(hexString: backgroundColor)
            b.titleLabel?.textColor = .init(hexString: textColor)
        
        b.layer.cornerRadius = 5
        return b
    }()
    lazy var closeBtn:UIButton = {
        var b = UIButton()
        let image = UIImage(systemName: "xmark")?
                   .withRenderingMode(.alwaysTemplate)
                
               b.setImage(image, for: .normal)
               b.imageView?.tintColor = .gray
               b.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        b.backgroundColor = .clear
        let color = survey.surveyInfo.themeColors.color23
            b.imageView?.tintColor = .init(hexString: color)
        
        
        return b
    }()
    
    init(survey: Survey, parameters:SurveyParameters, viewFrequency:String) {
        self.survey = survey
        self.parameters = parameters
        self.viewFrequency = viewFrequency
        self.followupManager=AliumAiFollowupManager(survey: survey)
        currQuest = survey.questions?.first
        super.init(nibName: nil, bundle: nil)
       
        self.followupManager.delegate = self
        guard currQuest != nil else{
            print("Curre Question is nil")
            dismiss(animated: false)
            return
        }
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
    }
    
    required init?(coder: NSCoder) { fatalError() }

    // MARK: -  ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
              self.frequencyManager = try FrequencyManagerFactory.getFrequencyManager(key: parameters.screenName, srvShowFreq: viewFrequency, customFreqSurveyData: nil)
        }catch{
            print(error)
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        setupUi()
         
        
    }
    
    // MARK: - setupUI
    func setupUi(){
        setupContainer()
        setupCloseBtn()
        setupQuestion()
        setupResponseContainer()
        setupNextBtn()
        showCurrentQuestion()
    }
    
    func setupContainer(){
        view.addSubview(container);
        let leading = container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
           let trailing = container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        let maxWidth:CGFloat = 600
        leading.priority = .defaultHigh
          trailing.priority = .defaultHigh
            container.activateConstraints([
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            container.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth > UIScreen.main.bounds.width ? UIScreen.main.bounds.width - 20 : maxWidth),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leading,trailing
        ])
    }
    func setupCloseBtn(){
        container.addSubview(closeBtn)
        closeBtn.activateConstraints([
            closeBtn.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10)
            ,
            closeBtn.topAnchor.constraint(equalTo: container.topAnchor, constant: 10)
            ,
            
        ])
    }
    func setupResponseContainer(){
        container.addSubview(responseContainer)
        responseContainer.activateConstraints([
            responseContainer.topAnchor.constraint(equalTo: question.bottomAnchor, constant: 10),
            responseContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10), responseContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
//                        responseContainer.heightAnchor.constraint(equalToConstant: 100)
            
        ])
        responseContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
      
       
        
//        question.activateConstraints([
//            question.bottomAnchor.constraint(equalTo: responseContainer.topAnchor)])
    }
    
    
    func setupNextBtn(){
        container.addSubview(nextBtn)
        nextBtnCenterX = nextBtn.centerXAnchor.constraint(equalTo: container.centerXAnchor)
          nextBtnTrailing = nextBtn.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10)
          nextBtnWidth = nextBtn.widthAnchor.constraint(greaterThanOrEqualToConstant: 120)

        nextBtn.activateConstraints([
            nextBtn.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            nextBtn.topAnchor.constraint(equalTo: responseContainer.bottomAnchor, constant: 15),
        ])
        
        nextBtn.addTarget(self, action: #selector(onNextPress), for: .touchUpInside)
        nextBtnWidth.isActive = true
    }
    
    func setupQuestion(){
        container.addSubview(question)
        question.activateConstraints([
            question.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            question.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 6)
            ,
            question.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10)
            ,
            question.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10)
            ,
        ])
    }
    
    func showCurrentQuestion(){

        
        guard let questions = survey.questions, index <= questions.count else{
            dismiss(animated: true)
            return
        }
        
        if index == ( questions.count ){
            dismiss(animated: true)
            return;
        }
        response = ""
        currQuest = questions[index]
    
        
        var text = (currQuest?.question ?? "")
        let required = currQuest?.questionSetting.required ?? false
      
        text += required ? "*" : ""
        
        question.text = text
        updateResponseContainer()
       
        if index == 0 { //when survey is loaded track and save freq
            track()
            if viewFrequency == "o" {
                frequencyManager?.recordSurveyTriggerOnPreferences()
            }
            if currQuest?.responseType == "0" {
                responseSubmitIndex = 2
            }
        }
        
       
    }
    
    func submitSurvey(){
        print("submit survey: index: \(index), viewfrequency: \(viewFrequency), responseType:\(currQuest?.responseType), submit index:\(responseSubmitIndex)")
        if index >= responseSubmitIndex
            &&
            viewFrequency == "os"
            &&
            currQuest?.responseType != "0"
        {
            frequencyManager?.recordSurveyTriggerOnPreferences()
        }
    }
    func updateResponseContainer(){
        input.delegate = nil
        input.textView.text = ""
        responseContainer.emptyView()
        
        let questions = survey.questions
        guard let questions else{
            return
        }
        
        guard let respType = currQuest?.responseType, let responseType = ResponseType(rawValue: respType) else {
            
            return
        }
        switch responseType {
            
        case .start:
            nextBtn.setTitle("start", for: .normal);
            
        case .longText:
             addMultilineTextInput()
            
        case .radio:
            addRadioTypeInput()
            
        case .checkbox:
            addCheckBoxTypeInput()
            
        case .nps:
            addNPSTypeInput()
            
        case .rating:
            addRatingTypeInput()
            
        case .opinion:
            addOpinionTypeInput()
            
        case .thankYou:
            nextBtn.setTitle("thankYou", for: .normal);
             
        }
        updateNextButton(responseType)
        
    }
    
    func handleNextQuestion(){
        
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
      
//            setupContainer()
          
    }
    func updateNextButton(_ respType:ResponseType){
        
        
        guard let currQuest else{
            dismiss(animated: false)
            return
        }
        
        enableBtn(nextBtn, flag: !currQuest.questionSetting.required)
        nextBtnCenterX.isActive = false
        nextBtnTrailing.isActive = false
         
        switch respType{
        case .start, .thankYou :
            nextBtn.setTitle(respType == ResponseType.start ? "Start" : "Close", for: .normal)
            nextBtnCenterX.isActive = true
       
        default:
            nextBtn.setTitle("Next", for: .normal)
            nextBtnTrailing.isActive = true
           
        }
        
       
        
    }
    
    func track(){
        print("tracking calledd....")
        guard let trackingParams = generateTrackingParameters() else{
            print("couldn't trackk....")
            return
        }
        print(trackingParams)
        AliumTracker.track(parameters: trackingParams )
    }
    

    @objc
    func onNextPress(_ sender:UIButton){
        print("index: \(index)")
        enableBtn(sender, flag: false)
        guard let currQuest else {
            dismiss(animated: true)
            return}
        if currQuest.responseType != "0" && currQuest.responseType != "-1" {
            track()
        }
        if currQuest.responseType == "1" &&  currQuest.aiSettings.enabled  {
            print("show ai followup")
            input.delegate = nil
            input.textView.text = ""
            followupManager.storePreviousFollowUp()
            let shouldStop = followupManager.shouldStop(freq: currQuest.aiSettings.maxFrequency)
            if(shouldStop){
                self.index += 1;
                self.showCurrentQuestion()
                return
            }
            followupManager.getFollowupQuestion(maxFollowups: currQuest.aiSettings.maxFrequency, currentIndex: index, originalResponse: response) { result in
                
                
                switch result{
                case .success(_):
//                    self.followupManager.aiFollowup = aiFollowup
                    self.enableBtn(sender, flag: true)
                case .failure(let error):
                    print(error)
                   
                    self.index += 1;
                    self.showCurrentQuestion()
                }
            }
            return;
        }
        index += 1;
        submitSurvey()
        showCurrentQuestion()
    }
    func enableBtn(_ sender:UIButton, flag:Bool){
        sender.isEnabled = flag
        sender.alpha = flag ? 1.0 : 0.8
    }
    @objc
    func onClose(_ sender:UIButton){
        dismiss(animated: true)
    }
    func generateTrackingParameters()->[String:Any]?{
        guard let currQuest else{
            return nil
        }
       
        var params: [String: Any] = parameters.customerVariables
        // Base params
        params["questionId"] = currQuest.id
        params["surveyLoadId"] = uuid
        params["surveyPath"] = parameters.screenName
        params["userId"] = ""
//        params["custId"] = aliumPreferences.customerId
//        params["userAgent"] = getUserAgent()
        params["eventType"] = ResponseType(rawValue: currQuest.responseType ?? "1") == .start ? "load" : "resp"
        params["language"] = "1"
        params["surveyType"] = 7
        params["respType"] = currQuest.responseType
        params["response"] = response

        // Survey info
        let surveyInfo = survey.surveyInfo
//        if let surveyInfo = survey.surveyInfo {
            params["surveyId"] = surveyInfo.surveyId
            params["orgId"] = surveyInfo.orgId
//        }

        // AI follow-up override
        if let questions = survey.questions,
           index < questions.count,
           questions[index].aiSettings.enabled == true,
           followupManager.followupIndex > -1,
           let aiFollowup = self.followupManager.aiFollowup {
            print("ai followup trackingparamares: \(aiFollowup.response) original resp; \(response)")
            params["aiQuestionId"] = followupManager.followupIndex + 1
            params["aiQuestionText"] = aiFollowup.followupQuestion
            params["respType"] = "15"
            params["response"] = aiFollowup.response
        }

        // Remove empty / null values (Android equivalent logic)
        params = params.filter { _, value in
            switch value {
            case let string as String:
                return !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            case let array as [Any]:
                return !array.isEmpty
            case let dict as [String: Any]:
                return !dict.isEmpty
            case Optional<Any>.none:
                return false
            default:
                return true
            }
        }
       print("final tracking response: \(params["response"])")
        if currQuest.responseType != "0"{
            guard let response = params["response"] as? String else {
                return nil
            }
            if response.isEmpty, response.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return nil
            }
        }
        return params
    }
}


