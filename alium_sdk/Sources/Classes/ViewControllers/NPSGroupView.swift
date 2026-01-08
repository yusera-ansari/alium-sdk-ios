//
//  NPSGroupView.swift
//  Pods
//
//  Created by yusera-ansari on 20/12/25.
//

import UIKit
import Foundation
final class NPSGroupView: UIView {
    weak var delegate: ALiumInputDelegate?
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var items: [NPSItemView] = []

   
    init(options: [String],backgroundColor:UIColor, textColor:UIColor, selectedBgColor:UIColor, selectedTextColor:UIColor) {
        super.init(frame: .zero)
        setupScrollView()
        setupStackView()
        createItems(options,backgroundColor, textColor,selectedBgColor,selectedTextColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupScrollView() {
//        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        scrollView.pin(to: self)
//        self.backgroundColor = .blue
//        scrollView.backgroundColor = .systemPink
        scrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }

    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            // Important: fixes height
            stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
        
    }

    private func createItems(_ options: [String],_ backgroundColor:UIColor, _ textColor:UIColor,_ selectedBgColor:UIColor, _ selectedTextColor:UIColor) {
        options.forEach { option in
            let item = NPSItemView(title: option, backgroundColor, textColor, selectedBgColor, selectedTextColor)
            item.addTarget(self, action: #selector(itemSelected(_:)), for: .valueChanged)
            items.append(item)
            stackView.addArrangedSubview(item)
        }
    }

    @objc private func itemSelected(_ sender: NPSItemView) {
        items.forEach { $0.isSelected = ($0 == sender)
            if($0 == sender){
                delegate?.onResponse(resp:  sender.title)
                delegate?.enableNext(flag: true)
            }
        }
        scrollToItem(sender)
    }

    private func scrollToItem(_ item: UIView) {
        let frame = item.convert(item.bounds, to: scrollView)
        scrollView.scrollRectToVisible(frame.insetBy(dx: -8, dy: 0), animated: true)
    }
}
