//
//  Checkboxgroup.swift
//  Pods
//
//  Created by yusera-ansari on 20/12/25.
//
import UIKit
import Foundation


final class CheckboxGroup: UIView, ALiumInputDelegate {
    func enableNext(flag: Bool) {
        
    }
    
    
    func onResponse(resp: String) {
        print("input response: \(resp)")
        guard let button = checkboxes.last else{ return}
        updateReposne(button, resp)
    }
    private let isOtherOptionsEnabled:Bool
    let input = MultilineTextInput()
    weak var delegate: ALiumInputDelegate?
    private var toggleInput  = true {
        didSet{
            input.isHidden = toggleInput
           if toggleInput{ input.textView.text = ""}
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
    
    private var checkboxes: [CheckboxView] = []
    private let stackView = UIStackView()
    
    var selectedOptions: [String] {
        checkboxes
            .filter { $0.isSelected }
            .compactMap { checkbox in
                checkbox.subviews
                    .compactMap { ($0 as? UIStackView)?.arrangedSubviews.last as? UILabel }
                    .first?.text
            }
    }

    init(options: [String], backgroundColor:UIColor, textColor:UIColor, iconColor:UIColor, isOtherOptionsEnabled:Bool) {
        self.isOtherOptionsEnabled=isOtherOptionsEnabled
        super.init(frame: .zero)
        setupStack()
        createCheckboxes(options,backgroundColor,textColor,iconColor)
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

    private func createCheckboxes(_ options: [String],_ backgroundColor:UIColor, _ textColor:UIColor,_  iconColor:UIColor) {
        options.forEach { option in
            let checkbox = CheckboxView(title: option, backgroundColor,textColor,iconColor)
            checkbox.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
            checkboxes.append(checkbox)
            stackView.addArrangedSubview(checkbox)
        }
    }

    @objc private func valueChanged(_ sender: CheckboxView) {
       
        updateReposne(sender, nil)
      
    }
    
    private func updateReposne(_ sender:CheckboxView,_ resp:String?){
        delegate?.enableNext(flag: false)
        if isOtherOptionsEnabled   {
            var response = ""
            let selectedCheckBox = checkboxes.filter{ $0.isSelected }
            
            for i in selectedCheckBox.indices {
                
                if(i == selectedCheckBox.count - 1){
//                    if last option is enabled, then we remove
                    if(selectedCheckBox[i] == checkboxes[checkboxes.count - 1]){ //other options checkbox

                        let resp = resp ?? ""
                        response += "\(selectedCheckBox[i].title)|\(resp)"
                        print(i, response)
                        if(selectedCheckBox.count == 1){
                            delegate?.enableNext(flag: !resp.isEmpty) //for required
                        }
                        break;
                    }
                    response += "\(selectedCheckBox[i].title)"
                    delegate?.enableNext(flag: true)
                    break;
                }
                if(selectedCheckBox[i] == checkboxes[checkboxes.count - 1]){ //other options checkbox
                   
                     let resp = resp ?? ""
    //                delegate?.onResponse(resp: selectedOptions.joined(separator: ","))
                    response += "\(selectedCheckBox[i].title)|\(resp),"
                    print(i, response)
                }else{
                        response += "\(selectedCheckBox[i].title),"
                    }
                   
                delegate?.enableNext(flag: true)
            }
            
           
            delegate?.onResponse(resp: response)
            guard let indexOfSender = checkboxes.firstIndex(of: sender) else{
                return
            }
            if indexOfSender == checkboxes.count - 1 {
                self.toggleInput = checkboxes[indexOfSender].isSelected ? false : true
            }
            
        }else {
            self.toggleInput = true //hide input
            delegate?.onResponse(resp: selectedOptions.joined(separator: ","))
            delegate?.enableNext(flag: !selectedOptions.joined(separator: ",").isEmpty )
        }
    }
}
