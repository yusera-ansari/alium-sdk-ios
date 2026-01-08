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
    let delegate:SurveyStateDelegate!
    var containerBottomConstraint : NSLayoutConstraint!
    let maxWidth:CGFloat = 450
    var containerWidth : NSLayoutConstraint!
    var leading:NSLayoutConstraint!
    var trailing:NSLayoutConstraint!
    var containerHeightAnchor:NSLayoutConstraint!
    
    var index:Int = 0{
        didSet{}
    };
    private var isKeyboardVisible = false
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
    lazy var responseScrollView:UIScrollView={
        var sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.showsVerticalScrollIndicator = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
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
    
    init(survey: Survey, parameters:SurveyParameters, viewFrequency:String, delegate:SurveyStateDelegate) {
        self.survey = survey
        self.parameters = parameters
        self.viewFrequency = viewFrequency
        self.followupManager=AliumAiFollowupManager(survey: survey)
        currQuest = survey.questions?.first
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
       
        self.followupManager.delegate = self
        guard currQuest != nil else{
            print("Curre Question is nil")
            dismiss(animated: false)
            delegate.onClose(parameters.screenName)
            return
        }
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
    }
    
    required init?(coder: NSCoder) { fatalError() }

    // MARK: -  ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObservers()
       addTapGesture()
        do{
              self.frequencyManager = try FrequencyManagerFactory.getFrequencyManager(key: parameters.screenName, srvShowFreq: viewFrequency, customFreqSurveyData: nil)
        }catch{
            print(error)
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        setupUi()
         
        
    }
    private func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))
            tap.cancelsTouchesInView = false
            tap.delegate = self
            view.addGestureRecognizer(tap)
    }
    @objc private func handleViewTap() {
        if isKeyboardVisible {
            view.endEditing(true)
        }else{
            dismiss(animated: true)
            delegate.onClose(parameters.screenName)
        }
        
    }
    // MARK: - setupUI
    func setupUi(){
        setupContainer()
        containerWidth.isActive = true
        setupCloseBtn()
        setupQuestion()
        setupResponseContainer()
        setupNextBtn()
        showCurrentQuestion()
    }
    
  
    func setupContainer(){
      
        view.addSubview(container);
        containerWidth = container.widthAnchor.constraint(equalToConstant: maxWidth > UIScreen.main.bounds.width ? UIScreen.main.bounds.width - 20 : maxWidth)
         leading = container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
            trailing = container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        containerHeightAnchor = container.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor)
        leading.priority = .defaultHigh
          trailing.priority = .defaultHigh
        
        
        containerBottomConstraint =  container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        
            container.activateConstraints([
           containerBottomConstraint,
           
//            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
         
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            leading,trailing
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
    var scrollViewHeight :NSLayoutConstraint!
    func setupResponseContainer(){
        container.addSubview(responseScrollView)
        responseScrollView.addSubview(responseContainer)
        
        scrollViewHeight = responseScrollView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.6)
       
                responseScrollView.activateConstraints([
                    responseScrollView.topAnchor.constraint(equalTo: question.bottomAnchor, constant: 10),
                    responseScrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10), responseScrollView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
                    scrollViewHeight
                ])
        responseContainer.activateConstraints([
            responseContainer.leadingAnchor.constraint(equalTo: responseScrollView.contentLayoutGuide.leadingAnchor),
                  responseContainer.trailingAnchor.constraint(equalTo: responseScrollView.contentLayoutGuide.trailingAnchor),
                  responseContainer.topAnchor.constraint(equalTo: responseScrollView.contentLayoutGuide.topAnchor),
                  responseContainer.bottomAnchor.constraint(equalTo: responseScrollView.contentLayoutGuide.bottomAnchor),

                  responseContainer.widthAnchor.constraint(equalTo: responseScrollView.frameLayoutGuide.widthAnchor)
              
        ])

        let expandableHeight = responseScrollView.heightAnchor
            .constraint(greaterThanOrEqualTo: responseContainer.heightAnchor)
        expandableHeight.priority = .defaultHigh
        expandableHeight.isActive = true
       
        
    }
    
    
    func setupNextBtn(){
        container.addSubview(nextBtn)
        nextBtnCenterX = nextBtn.centerXAnchor.constraint(equalTo: container.centerXAnchor)
          nextBtnTrailing = nextBtn.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10)
          nextBtnWidth = nextBtn.widthAnchor.constraint(greaterThanOrEqualToConstant: 120)

        nextBtn.activateConstraints([
            nextBtn.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            nextBtn.topAnchor.constraint(equalTo: responseScrollView.bottomAnchor, constant: 15),
//            responseScrollView.bottomAnchor.constraint(equalTo: nextBtn.topAnchor, constant: -15)
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
            delegate.onClose(parameters.screenName)
            return
        }
        
        if index == ( questions.count ){
            dismiss(animated: true)
            delegate.onClose(parameters.screenName)
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
        responseScrollView.isHidden = false
    
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
            responseScrollView.isHidden = true
            
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
           
            responseScrollView.isHidden = true
            scrollViewHeight.isActive = false
            containerHeightAnchor.isActive = false
            nextBtn.setTitle("thankYou", for: .normal);
            
        }
        updateNextButton(responseType)
        
    }
    
//    Mark: Handle Traits
   
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print("trait class changedddd... \(traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass || traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass),  ")
        print(traitCollection.horizontalSizeClass)
        print(traitCollection.verticalSizeClass)
        print(previousTraitCollection?.horizontalSizeClass )
        print(previousTraitCollection?.verticalSizeClass)
//            setupContainer()
        guard traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass || traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass else {return}
        print("screen width: \(UIScreen.main.bounds.width)")
        containerHeightAnchor.isActive = false
        
 
        handleSizeClassChange()
          
    }
    private func handleSizeClassChange() {
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        switch (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass) {

        case (.compact, .regular): // Portrait
            
              containerWidth.constant = min(maxWidth, screenWidth - 20)
   
        case (.regular, .compact): // Landscape
            print("trait landscape")
              containerWidth.constant = min(maxWidth, screenWidth - 40)
            containerHeightAnchor.constant = screenHeight - 40
            containerHeightAnchor.isActive = true
            
        case (.regular, .regular): // iPad
            containerWidth.constant = 600
         
        default:
            print("trait default")
            containerWidth.constant = min(maxWidth, screenWidth - 20)
            containerHeightAnchor.constant = screenHeight - 40
            containerHeightAnchor.isActive = true
           
        }
        view.layoutIfNeeded()
        
        print("trait: \(containerWidth) ")
    }

    
//    Mark: - update next button
    func updateNextButton(_ respType:ResponseType){
        
        
        guard let currQuest else{
            dismiss(animated: false)
            delegate.onClose(parameters.screenName)
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
    
  
    

    @objc
    func onNextPress(_ sender:UIButton){
        print("index: \(index)")
        enableBtn(sender, flag: false)
        guard let currQuest else {
            dismiss(animated: true)
            delegate.onClose(parameters.screenName)
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
        delegate.onClose(parameters.screenName)
    }
    
//    Mark: - Tracking parameters
    func track(){
        print("tracking calledd....")
        guard let trackingParams = generateTrackingParameters() else{
            print("couldn't trackk....")
            return
        }
        print(trackingParams)
        AliumTracker.track(parameters: trackingParams )
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
        params["custId"] = AliumUserDefaults.shared.get("customer-id") 
        params["userAgent"] = DeviceInfo.getUserAgent()
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
    
//    Mark: - KeyboardObservers
  

    private func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc
    private func onKeyboardWillShow(_ notification: Notification){
        print("keyboard is showing....")
        guard
               let userInfo = notification.userInfo,
               let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
               let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
               let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
           else { return }

           let keyboardHeight = keyboardFrame.height
           let safeBottom = view.safeAreaInsets.bottom

           containerBottomConstraint.constant = -(keyboardHeight - safeBottom + 12)

           UIView.animate(
               withDuration: duration,
               delay: 0,
               options: UIView.AnimationOptions(rawValue: curve << 16),
               animations: {
                   self.view.layoutIfNeeded()
               }
           )
        isKeyboardVisible = true
        
    }
    @objc
    private func onKeyboardWillHide(_ notification: Notification){
        print("keyboard will hide now!!")
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else{return}
        containerBottomConstraint.constant = -20
        UIView.animate(withDuration: duration, delay: 0,
                       options: UIView.AnimationOptions(rawValue: curve << 16))
        {
            self.view.layoutIfNeeded()
        }
        isKeyboardVisible = false
    }
    
//   Mark: - Dismiss
    override func viewDidDisappear(_ animated: Bool) {
        if isBeingDismissed {
            delegate.onClose(parameters.screenName)
        }
    }
//     Mark: - deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// Mark: - OverlayViewController : UIGestureRecognizerDelegate
extension OverlayViewController : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: view)
        
        if container.frame.contains(location) {
            return false
        }
        return true
    }
}
