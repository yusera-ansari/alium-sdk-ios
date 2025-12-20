//
//  OverlayViewController.swift
//  Pods
//
//  Created by yusera-ansari on 15/12/25.
//

import UIKit
import SwiftUI



class OverlayViewController: UIViewController {

    private let survey: Survey
    private var index:Int = 0;
    lazy var container : UIView = {
        var v : UIView = UIView()
        v.backgroundColor = .lightGray
        if let color = survey.surveyInfo.themeColors?.color1 {
            v.backgroundColor = .init(hexString: color )
        }
        v.layer.cornerRadius = 10
        return v;
    }()
    lazy var responseContainer:UIView = {
        var l = UIView()
        
        return l
    }()
    lazy var question:UILabel = {
        let l = UILabel()
       if let color = survey.surveyInfo.themeColors?.color2 {
            l.textColor = .init(hexString:color )
        }
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
        if let backgroundColor = survey.surveyInfo.themeColors?.color3, let textColor = survey.surveyInfo.themeColors?.color4 {
            b.backgroundColor = .init(hexString: backgroundColor)
            b.titleLabel?.textColor = .init(hexString: textColor)
        }
        b.layer.cornerRadius = 5
        return b
    }()
    lazy var closeBtn:UIButton = {
        var b = UIButton()
        let image = UIImage(systemName: "xmark")?
                   .withRenderingMode(.alwaysTemplate)
                
               b.setImage(image, for: .normal)
               b.imageView?.tintColor = .gray
//               b.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        b.backgroundColor = .clear
        if let color = survey.surveyInfo.themeColors?.color23 {
            b.imageView?.tintColor = .init(hexString: color)
        }
        
        return b
    }()
    init(survey: Survey) {
        self.survey = survey
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
    }
    
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        setupUi()
         
        
    }
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
        
        leading.priority = .defaultHigh
          trailing.priority = .defaultHigh
            container.activateConstraints([
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            container.widthAnchor.constraint(lessThanOrEqualToConstant: 600),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leading,trailing
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
    
    
    func setupCloseBtn(){
        container.addSubview(closeBtn)
        closeBtn.activateConstraints([
            closeBtn.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10)
            ,
            closeBtn.topAnchor.constraint(equalTo: container.topAnchor, constant: 10)
            ,
            
        ])
    }
    func setupNextBtn(){
        container.addSubview(nextBtn)
        nextBtnCenterX = nextBtn.centerXAnchor.constraint(equalTo: container.centerXAnchor)
          nextBtnTrailing = nextBtn.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10)
          nextBtnWidth = nextBtn.widthAnchor.constraint(greaterThanOrEqualToConstant: 120)

        nextBtn.activateConstraints([
            nextBtn.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            nextBtn.topAnchor.constraint(equalTo: responseContainer.bottomAnchor, constant: 5),
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
            return
        }
        
        if index == ( questions.count ){
            dismiss(animated: true)
            return;
        }
       
    
        let currentQuest = questions[index]
        var text = (currentQuest.question ?? "")
        if let required = currentQuest.questionSetting?.required {
            text += required ? "*" : ""
        }
        question.text = text + "**"
        updateResponseContainer()
        
        
    }
    func updateResponseContainer(){
        responseContainer.emptyView()
        let questions = survey.questions
        guard let questions else{
            return
        }
        var currQuestion = questions[index]
        guard let respType = currQuestion.responseType, let responseType = ResponseType(rawValue: respType) else {
            
            return
        }
        switch responseType {
            
        case .start:
            nextBtn.setTitle("start", for: .normal);
        case .longText:
             addMultilineTextInput()
        case .radio:
            nextBtn.setTitle("radio", for: .normal);
        case .checkbox:
            nextBtn.setTitle("checkbox", for: .normal);
        case .nps:
            nextBtn.setTitle("nps", for: .normal);
        case .rating:
            nextBtn.setTitle("rating", for: .normal);
        case .opinion:
            nextBtn.setTitle("opinion", for: .normal);
        case .thankYou:
            nextBtn.setTitle("thankYou", for: .normal);
             
        }
        updatedNextButton(responseType)
        
    }
    
    func handleNextQuestion(){
        
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
      
//            setupContainer()
          
    }
    func updatedNextButton(_ respType:ResponseType){
        guard let questions = survey.questions else{return}
        let currQuest = questions[index]
        
        nextBtnCenterX.isActive = false
        nextBtnTrailing.isActive = false
         
        switch respType{
        case .start, .thankYou :
            nextBtn.setTitle(respType == ResponseType.start ? "Start" : "Close", for: .normal)
            nextBtnTrailing.isActive = true
       
        default:
            nextBtn.setTitle("Next", for: .normal)
            nextBtnCenterX.isActive = true
        }
       
        
    }

    @objc
    func onNextPress(_ sender:UIButton){
        index += 1;
//        update button
        showCurrentQuestion()
    }
    
}


