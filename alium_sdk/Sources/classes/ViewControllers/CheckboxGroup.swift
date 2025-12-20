//
//  Checkboxgroup.swift
//  Pods
//
//  Created by yusera-ansari on 20/12/25.
//

final class CheckboxGroup: UIView {

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

    init(options: [String]) {
        super.init(frame: .zero)
        setupStack()
        createCheckboxes(options)
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

    private func createCheckboxes(_ options: [String]) {
        options.forEach { option in
            let checkbox = CheckboxView(title: option)
            checkbox.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
            checkboxes.append(checkbox)
            stackView.addArrangedSubview(checkbox)
        }
    }

    @objc private func valueChanged(_ sender: CheckboxView) {
        print("Selected options:", selectedOptions)
    }
}
