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
    private let placeholderLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        heightAnchor.constraint(greaterThanOrEqualToConstant: 140).isActive = true
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
        placeholderLabel.isHidden = !textView.text.isEmpty
        delegate?.onResponse(resp: textView.text)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
}
