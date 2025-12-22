//
//  RatingGroupView.swift
//  Pods
//
//  Created by yusera-ansari on 22/12/25.
//

final class RatingGroupView: UIView {
    private let stackView = UIStackView()
     private var items: [RatingItemView] = []

     private let responseOptions: [String]
     private let style: RatingStyle

     var selectedIndex: Int? {
         items.first(where: { $0.isSelected })?.index
     }

     var selectedOption: String? {
         guard let index = selectedIndex else { return nil }
         return responseOptions[index]
     }

     init(responseOptions: [String], style: RatingStyle) {
         self.responseOptions = responseOptions
         self.style = style
         super.init(frame: .zero)
         setupStack()
         createItems()
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     private func setupStack() {
         stackView.axis = .horizontal
         stackView.spacing = 8
         stackView.alignment = .fill
         stackView.distribution = .fillEqually
         stackView.translatesAutoresizingMaskIntoConstraints = false

         addSubview(stackView)
         stackView.pin(to: self)
     }

     private func createItems() {
         for index in 0..<responseOptions.count {
             let item = RatingItemView(index: index, style: style)
             item.addTarget(self, action: #selector(itemSelected(_:)), for: .valueChanged)
             items.append(item)
             stackView.addArrangedSubview(item)
         }
     }

     @objc private func itemSelected(_ sender: RatingItemView) {
         items.forEach { $0.isSelected = ($0 == sender) }
         print("Selected:", selectedOption ?? "")
     }
}
