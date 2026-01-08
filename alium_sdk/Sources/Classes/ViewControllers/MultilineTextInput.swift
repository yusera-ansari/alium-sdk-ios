//
//  MultilineTextInput.swift
//  Pods
//
//  Created by yusera-ansari on 18/12/25.
//
import UIKit
import Foundation

final class MultilineTextInput: UIView {
    weak var delegate: ALiumInputDelegate?
    let textView = UITextView()
    let placeholderLabel = UILabel()
    private var heightAnch:NSLayoutConstraint!
    var maxHeight:CGFloat = 120 {
        didSet{
            self.removeConstraint(heightAnch)
            self.heightAnch = heightAnchor.constraint(greaterThanOrEqualToConstant: maxHeight)
            self.heightAnch.isActive = true
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.heightAnch = heightAnchor.constraint(greaterThanOrEqualToConstant: maxHeight)
        self.heightAnch.isActive = true
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.heightAnch = heightAnchor.constraint(greaterThanOrEqualToConstant: maxHeight)
        self.heightAnch.isActive = true
        setup()
    }

    private func setup() {
       
        print("maxHeight: \(maxHeight)")
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        // TextView
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 16)
//        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 6, bottom: 10, right: 6)
        textView.delegate = self
        textView.showsVerticalScrollIndicator = false
        // Placeholder
        placeholderLabel.textColor = .lightGray
        placeholderLabel.font = textView.font
//        placeholderLabel.numberOfLines = 0

        addSubview(textView)
        addSubview(placeholderLabel)
//        textView.returnKeyType = .done
        textView.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),

            placeholderLabel.topAnchor.constraint(equalTo: topAnchor,constant: 5),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }

    func setPlaceholder(_ text: String) {
        placeholderLabel.text = text
    }
}

extension MultilineTextInput: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print("text view did change with \(textView.text)")
        placeholderLabel.isHidden = !textView.text.isEmpty
        delegate?.onResponse(resp: textView.text)
        delegate?.enableNext(flag: !textView.text.isEmpty)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
}
