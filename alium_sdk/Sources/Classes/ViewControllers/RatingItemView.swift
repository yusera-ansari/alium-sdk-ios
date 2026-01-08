//
//  RatingItemView.swift
//  Pods
//
//  Created by yusera-ansari on 22/12/25.
//

import UIKit

enum RatingStyle:String {
    case star = "stars"
    case emoji = "emoji"
    case tick = "ticks"
    case heart = "hearts"
    case buttons = "buttons"
}

final class RatingItemView: UIControl {
    let index: Int
     private let imageView = UIImageView()
     private let label = UILabel()
     private let style: RatingStyle
    private let bgColor:UIColor
    private let textColor:UIColor
    private let selectedBgColor:UIColor
    private let selectedTextColor:UIColor
        private let emojiTypes = ["line_md_emoji_cry","line_md_emoji_frown","mingcute_emoji_smile","ic_baseline_emoji_emotions","fluent_emoji_laugh"]
     override var isSelected: Bool {
         didSet {
             configureSymbol()
             updateUI() }
     }

     init(index: Int, style: RatingStyle,_ backgroundColor:UIColor,_ textColor:UIColor, _ selectedBackgroundColor:UIColor,_ selectedTextColor:UIColor ) {
         self.index = index
         self.style = style
         self.bgColor = backgroundColor
         self.textColor = textColor
         self.selectedBgColor = selectedBackgroundColor
         self.selectedTextColor = selectedTextColor
         super.init(frame: .zero)
         setupUI()
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     private func setupUI() {
         heightAnchor.constraint(equalToConstant: 44).isActive = true
        

         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.contentMode = .scaleAspectFit

         label.translatesAutoresizingMaskIntoConstraints = false
         label.font = .systemFont(ofSize: 16, weight: .medium)
         label.textAlignment = .center

         let container = UIView()
         container.isUserInteractionEnabled = false
         container.translatesAutoresizingMaskIntoConstraints = false

         container.addSubview(imageView)
         container.addSubview(label)
         addSubview(container)
         container.pin(to: self)

         NSLayoutConstraint.activate([
             container.centerXAnchor.constraint(equalTo: centerXAnchor),
             container.centerYAnchor.constraint(equalTo: centerYAnchor),

//             imageView.widthAnchor.constraint(equalToConstant: 22),
//             imageView.heightAnchor.constraint(equalToConstant: 22),
             imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
             imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),

             label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
             label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
         ])
         imageView.pin(to: container)

         configureSymbol()
         addTarget(self, action: #selector(tapped), for: .touchUpInside)
         updateUI()
     }

     private func configureSymbol() {
         switch style {
             
         case .star:
             imageView.image = UIImage(systemName: isSelected ? "star.fill" : "star")
             label.isHidden = true

         case .heart:
             imageView.image = UIImage(systemName:isSelected ? "heart.fill" : "heart")
             label.isHidden = true

         case .tick:
             guard
                let bundle = AliumBundle.getBundle() else{return}
             imageView.image = UIImage(named: "hugeicons_tick_double", in : bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
             label.isHidden = true

         case .emoji:
             guard let bundle = AliumBundle.getBundle() else{return}
             imageView.image = UIImage(named:isSelected ? emojiTypes[min(index, emojiTypes.count - 1)] : "line_md_emoji_smile", in:bundle , compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
//             imageView.tintColor = .black
             label.isHidden = true

         case .buttons:
             layer.cornerRadius = 4
             layer.borderWidth = 0
             label.text = "\(index + 1)"
             label.textColor = isSelected ? selectedTextColor : textColor
             layer.backgroundColor = isSelected ? selectedBgColor.cgColor : bgColor.cgColor
             imageView.isHidden = true
         }
     }

     private func updateUI() {
         let tint = isSelected ? selectedBgColor : bgColor
         imageView.tintColor = tint
//         label.textColor = tint
//         layer.borderColor = tint?.cgColor
//         backgroundColor = isSelected ? tint?.withAlphaComponent(0.1) : .clear
     }

     @objc private func tapped() {
         sendActions(for: .valueChanged)
     }
}

