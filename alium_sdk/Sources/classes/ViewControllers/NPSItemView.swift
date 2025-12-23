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

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .systemBlue : .clear
            label.textColor = isSelected ? .white : .systemBlue
            layer.borderColor = isSelected
                ? UIColor.systemBlue.cgColor
                : UIColor.systemBlue.cgColor
        }
    }

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setupUI(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(title: String) {
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor

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
