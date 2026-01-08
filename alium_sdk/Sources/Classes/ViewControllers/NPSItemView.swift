//
//  NPSItemView.swift
//  Pods
//
//  Created by yusera-ansari on 20/12/25.
//

import UIKit

final class NPSItemView: UIControl {
    let title :String
    private let label = UILabel()
    private let bgColor:UIColor
    private let textColor:UIColor
    private let selectedBgColor:UIColor
    private let selectedTextColor:UIColor
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? selectedBgColor : bgColor
            label.textColor = isSelected ? selectedTextColor : textColor
//            layer.borderColor = isSelected
//            ? activeColor.cgColor
//            : inactiveColor.cgColor
        }
    }

    init(title: String,_ backgroundColor:UIColor, _ textColor:UIColor, _ selectedBgColor:UIColor, _ selectedTextColor:UIColor ) {
        self.title = title
        self.bgColor = backgroundColor
        self.textColor = textColor
        self.selectedBgColor = selectedBgColor
        self.selectedTextColor = selectedTextColor
        super.init(frame: .zero)
        setupUI(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(title: String) {
        layer.cornerRadius = 4
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.systemBlue.cgColor
        backgroundColor = isSelected ? selectedBgColor : bgColor
        label.textColor = isSelected ? selectedTextColor : textColor
        label.text = title
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 36),
            widthAnchor.constraint(equalToConstant: 36),

            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @objc private func didTap() {
        sendActions(for: .valueChanged)
    }
}
