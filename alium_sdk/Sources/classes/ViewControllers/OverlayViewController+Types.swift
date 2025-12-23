//
//  OverlayViewController+Types.swift
//  Pods
//
//  Created by yusera-ansari on 18/12/25.
//
enum ResponseType: String {
    case start = "0"
    case longText = "1"
    case radio = "2"
    case checkbox = "3"
    case nps = "4"
    case rating = "5"
    case opinion = "6"
    case thankYou = "-1"
}
extension OverlayViewController{
    func addMultilineTextInput(){
        let input = MultilineTextInput()
        input.delegate = self
        responseContainer.addSubview(input)
        input.pin(toMarginOf: responseContainer)
        input.setPlaceholder("Enter you response here")
    
//        var v = UIView()
//        responseContainer.addSubview(v)
//        v.pin(to: responseContainer)
//        v.backgroundColor = .blue
//        v.layer.cornerRadius = 10
//        v.clipsToBounds = true
//        v.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
//        
//        let txtView = UITextView()
//        txtView.text = ""
////        label.contentVerticalAlignment = .top
//        v.addSubview(txtView)
//        txtView.pin(to: v)
//        txtView.backgroundColor = .brown
//        txtView.font = .systemFont(ofSize: 16)
//        txtView.textContainerInset = .init(top: 5, left: 5, bottom: 5, right: 5)
//        
//        let placeHolderText = UILabel()
//        placeHolderText.text = "Enter you response here"
//        placeHolderText.textColor = .gray
//        placeHolderText.font = .systemFont(ofSize: 16)
//        v.addSubview(placeHolderText)
//        placeHolderText.activateConstraints([
//            placeHolderText.topAnchor.constraint(equalTo: v.topAnchor, constant: 5)
//            ,
//            placeHolderText.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 5)
//        ])
//        
    
       
    }
    
    func addRadioTypeInput(){
        guard let questions = survey.questions else{return }
        let currQuest = questions[index]
        
        let radioGroup = RadioButtonGroup(options: currQuest.responseOptions)
        radioGroup.delegate = self
              radioGroup.translatesAutoresizingMaskIntoConstraints = false
              responseContainer.addSubview(radioGroup)

        radioGroup.pin(to: responseContainer)
    }
    
    func addCheckBoxTypeInput(){
        guard let questions = survey.questions else{return }
        let currQuest = questions[index]
        let checkboxGroup = CheckboxGroup(options: currQuest.responseOptions)
        checkboxGroup.delegate = self
               checkboxGroup.translatesAutoresizingMaskIntoConstraints = false
               responseContainer.addSubview(checkboxGroup)
        checkboxGroup.pin(to: responseContainer)
    }
    
    func addNPSTypeInput(){
        guard let questions = survey.questions else{return }
        let currQuest = questions[index]
        let npsGroup = NPSGroupView(options: currQuest.responseOptions)
        npsGroup.delegate = self
        npsGroup.translatesAutoresizingMaskIntoConstraints = false
               responseContainer.addSubview(npsGroup)
        npsGroup.pin(to: responseContainer)
//        npsGroup.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 20).isActive = true
        
//        NSLayoutConstraint.activate([
//            npsGroup.topAnchor.constraint(equalTo: responseContainer.topAnchor),
//            npsGroup.bottomAnchor.constraint(equalTo: responseContainer.bottomAnchor),
//            npsGroup.centerXAnchor.constraint(equalTo: responseContainer.centerXAnchor),
//
//            // screen width - 20
//            npsGroup.leadingAnchor.constraint(
//                greaterThanOrEqualTo: responseContainer.leadingAnchor,
//                constant: 10
//            ),
//            npsGroup.trailingAnchor.constraint(
//                lessThanOrEqualTo: responseContainer.trailingAnchor,
//                constant: -10
//            ),
//
//            // max width = 600
//            npsGroup.widthAnchor.constraint(lessThanOrEqualToConstant: 600)
//        ])
        
    }
    func addOpinionTypeInput(){
        guard let questions = survey.questions else{return }
        let currQuest = questions[index]
        let npsGroup = NPSGroupView(options: currQuest.responseOptions)
        npsGroup.delegate = self
        npsGroup.translatesAutoresizingMaskIntoConstraints = false
        responseContainer.addSubview(npsGroup)
        npsGroup.pin(to: responseContainer)}
    
    func addRatingTypeInput(){
        guard let questions = survey.questions else{return }
        let currQuest = questions[index]
        guard let type = currQuest.questionSetting?.ratingType else{return}
        
        let responseType = RatingStyle(rawValue: type) ?? RatingStyle.star
        let ratingGroup = RatingGroupView(responseOptions: currQuest.responseOptions, style: responseType)
        ratingGroup.delegate = self
        ratingGroup.tintColor = .magenta
        
        ratingGroup.translatesAutoresizingMaskIntoConstraints = false
        responseContainer.addSubview(ratingGroup)
        //        ratingGroup.pin(to: responseContainer)}
        ratingGroup.activateConstraints([
            ratingGroup.widthAnchor.constraint(equalTo: responseContainer.widthAnchor, multiplier: 0.7),
            ratingGroup.topAnchor.constraint(equalTo: responseContainer.topAnchor),
            ratingGroup.bottomAnchor.constraint(equalTo: responseContainer.bottomAnchor),
            ratingGroup.centerXAnchor.constraint(equalTo: responseContainer.centerXAnchor)
        ]
        )
    }

}
