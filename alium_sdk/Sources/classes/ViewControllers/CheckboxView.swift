//
//  CheckboxView.swift
//  Pods
//
//  Created by yusera-ansari on 20/12/25.
//

import UIKit

final class CheckboxView: UIControl {

    private let boxView = UIView()
    private let checkmarkView = UIImageView()
    private let titleLabel = UILabel()
    private let iconColor:UIColor
    private let textColor:UIColor
    private let bgColor:UIColor
    let title:String
    override var isSelected: Bool {
        didSet {
            checkmarkView.isHidden = !isSelected
            boxView.backgroundColor = isSelected ? iconColor : .clear
        }
    }

    init(title: String,_ backgroundColor:UIColor,_ textColor:UIColor,_ iconColor:UIColor) {
        self.title = title
        self.iconColor = iconColor
        self.bgColor = backgroundColor
        self.textColor = textColor
        super.init(frame: .zero)
        setupUI(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(title: String) {
        backgroundColor = bgColor
        layer.cornerRadius = 5
        // Box
        boxView.layer.cornerRadius = 4
        boxView.layer.borderWidth = 2
        boxView.layer.borderColor = iconColor.cgColor
        boxView.translatesAutoresizingMaskIntoConstraints = false

        // Checkmark
        checkmarkView.image = UIImage(systemName: "checkmark")
        checkmarkView.tintColor = .white
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.isHidden = true

        boxView.addSubview(checkmarkView)

        NSLayoutConstraint.activate([
            checkmarkView.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
            checkmarkView.centerYAnchor.constraint(equalTo: boxView.centerYAnchor)
        ])

        // Label
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Stack
        let stack = UIStackView(arrangedSubviews: [boxView, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isUserInteractionEnabled = false // ✅ important

        addSubview(stack)
        stack.pin(to: self, constant: 10)
        NSLayoutConstraint.activate([
            boxView.widthAnchor.constraint(equalToConstant: 22),
            boxView.heightAnchor.constraint(equalToConstant: 22),

          
        ])

        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @objc private func didTap() {
        isSelected.toggle()
        sendActions(for: .valueChanged)
    }
}
