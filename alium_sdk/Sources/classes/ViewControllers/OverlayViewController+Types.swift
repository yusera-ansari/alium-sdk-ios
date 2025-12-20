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

              radioGroup.translatesAutoresizingMaskIntoConstraints = false
              responseContainer.addSubview(radioGroup)

        radioGroup.pin(to: responseContainer)
    }
}
