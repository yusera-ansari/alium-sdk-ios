//
//  RadioButtonView.swift
//  Pods
//
//  Created by yusera-ansari on 20/12/25.
//

import UIKit

final class RadioButtonView: UIControl {

    private let outerCircle = UIView()
    private let innerCircle = UIView()
    private let titleLabel = UILabel()

    override var isSelected: Bool {
        didSet {
            innerCircle.isHidden = !isSelected
        }
    }

    init(title: String) {
        super.init(frame: .zero)
        setupUI(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(title: String) {
        backgroundColor = .white
        layer.cornerRadius = 5
        // Outer circle
        outerCircle.layer.cornerRadius = 10
        outerCircle.layer.borderWidth = 2
        outerCircle.layer.borderColor = UIColor.systemBlue.cgColor
        outerCircle.translatesAutoresizingMaskIntoConstraints = false

        // Inner circle
        innerCircle.layer.cornerRadius = 6
        innerCircle.backgroundColor = .systemBlue
        innerCircle.translatesAutoresizingMaskIntoConstraints = false
        innerCircle.isHidden = true

        outerCircle.addSubview(innerCircle)

        NSLayoutConstraint.activate([
            innerCircle.centerXAnchor.constraint(equalTo: outerCircle.centerXAnchor),
            innerCircle.centerYAnchor.constraint(equalTo: outerCircle.centerYAnchor),
            innerCircle.widthAnchor.constraint(equalToConstant: 14),
            innerCircle.heightAnchor.constraint(equalToConstant: 14)
        ])

        // Label
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Stack
        let stack = UIStackView(arrangedSubviews: [outerCircle, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isUserInteractionEnabled = false
        addSubview(stack)
        stack.pin(to: self, constant: 10)
        NSLayoutConstraint.activate([
            outerCircle.widthAnchor.constraint(equalToConstant: 22),
            outerCircle.heightAnchor.constraint(equalToConstant: 22),
        ])

        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @objc private func didTap() {
        sendActions(for: .valueChanged)
    }
}
