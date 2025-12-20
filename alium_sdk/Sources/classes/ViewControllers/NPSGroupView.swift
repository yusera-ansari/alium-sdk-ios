//
//  NPSGroupView.swift
//  Pods
//
//  Created by yusera-ansari on 20/12/25.
//


final class NPSGroupView: UIView {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var items: [NPSItemView] = []

   
    init(options: [String]) {
        super.init(frame: .zero)
        setupScrollView()
        setupStackView()
        createItems(options)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupScrollView() {
//        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        scrollView.pin(to: self)
    }

    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),

            // Important: fixes height
            stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }

    private func createItems(_ options: [String]) {
        options.forEach { option in
            let item = NPSItemView(title: option)
            item.addTarget(self, action: #selector(itemSelected(_:)), for: .valueChanged)
            items.append(item)
            stackView.addArrangedSubview(item)
        }
    }

    @objc private func itemSelected(_ sender: NPSItemView) {
        items.forEach { $0.isSelected = ($0 == sender) }
        scrollToItem(sender)
    }

    private func scrollToItem(_ item: UIView) {
        let frame = item.convert(item.bounds, to: scrollView)
        scrollView.scrollRectToVisible(frame.insetBy(dx: -8, dy: 0), animated: true)
    }
}
