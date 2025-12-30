//
//  RadioButtonGroup.swift
//  Pods
//
//  Created by yusera-ansari on 20/12/25.
//
import UIKit
import Foundation
final class RadioButtonGroup: UIView, ALiumInputDelegate {
    func onResponse(resp: String) {
        print("input response: \(resp)")
        guard let button = buttons.last else{ return}
        updateReposne(button, resp)
    }
    let input = MultilineTextInput()
    weak var delegate: ALiumInputDelegate?
    private var toggleInput  = true {
        didSet{
            input.isHidden = toggleInput
        }
    }
    private var buttons: [RadioButtonView] = []
    private let stackView = UIStackView()
    private var options : [String] = []
    private let isOtherOptionsEnabled : Bool
   
    var selectedOption: String? {
        guard let selected = buttons.first(where: { $0.isSelected }) else {
            return nil
        }
        return selected.subviews
            .compactMap { ($0 as? UIStackView)?.arrangedSubviews.last as? UILabel }
            .first?.text
    }

    init(options: [String], backgroundColor: UIColor, textColor: UIColor,iconColor: UIColor, isOtherOptionsEnabled:Bool ) {
        self.options = options
        self.isOtherOptionsEnabled = isOtherOptionsEnabled
        super.init(frame: .zero)
        setupStack()
        createButtons(options, backgroundColor, textColor,iconColor)
        setupInput()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStack() {
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.pin(to: self)
    }

    private func createButtons(_ options: [String],_ backgroundColor: UIColor, _ textColor: UIColor,_ iconColor: UIColor ) {
        options.forEach { option in
            let button = RadioButtonView(title: option, backgroundColor: backgroundColor, textColor: textColor,iconColor: iconColor )
            button.addTarget(self, action: #selector(optionSelected(_:)), for: .valueChanged)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func setupInput(){
        input.maxHeight = 60
        input.delegate = self
        stackView.addArrangedSubview(input)
//        input.pin(toMarginOf: responseContainer)
        input.setPlaceholder("Enter you response here")
        input.isHidden = true
    }
    
    @objc private func optionSelected(_ sender: RadioButtonView) {
        buttons.forEach {
            $0.isSelected = ($0 == sender)
           if($0 == sender) { //if check to avoid multiple updates
               updateReposne(sender, nil)
            }
        }
    }
    
    private func updateReposne(_ sender:RadioButtonView,_ resp:String?){
        if isOtherOptionsEnabled   {
            guard let indexOfSender = options.firstIndex(of: sender.title) else{
                return
            }
            if(indexOfSender == options.count - 1){
                self.toggleInput = false
                 let resp = resp ?? ""
                delegate?.onResponse(resp:"\(sender.title)|\(resp)")
            }else{
                self.toggleInput = true
                delegate?.onResponse(resp:sender.title )
            }
           
        }else {
            delegate?.onResponse(resp:sender.title )
        }
    }
}

