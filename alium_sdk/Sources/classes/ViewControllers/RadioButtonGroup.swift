//
//  RadioButtonGroup.swift
//  Pods
//
//  Created by yusera-ansari on 20/12/25.
//

final class RadioButtonGroup: UIView {

    private var buttons: [RadioButtonView] = []
    private let stackView = UIStackView()

    var selectedOption: String? {
        guard let selected = buttons.first(where: { $0.isSelected }) else {
            return nil
        }
        return selected.subviews
            .compactMap { ($0 as? UIStackView)?.arrangedSubviews.last as? UILabel }
            .first?.text
    }

    init(options: [String]) {
        super.init(frame: .zero)
        setupStack()
        createButtons(options)
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

    private func createButtons(_ options: [String]) {
        options.forEach { option in
            let button = RadioButtonView(title: option)
            button.addTarget(self, action: #selector(optionSelected(_:)), for: .valueChanged)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }

    @objc private func optionSelected(_ sender: RadioButtonView) {
        buttons.forEach { $0.isSelected = ($0 == sender) }
    }
}

