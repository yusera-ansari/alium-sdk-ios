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

     override var isSelected: Bool {
         didSet { updateUI() }
     }

     init(index: Int, style: RatingStyle) {
         self.index = index
         self.style = style
         super.init(frame: .zero)
         setupUI()
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     private func setupUI() {
         heightAnchor.constraint(equalToConstant: 44).isActive = true
         layer.cornerRadius = 8
         layer.borderWidth = 1

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

         NSLayoutConstraint.activate([
             container.centerXAnchor.constraint(equalTo: centerXAnchor),
             container.centerYAnchor.constraint(equalTo: centerYAnchor),

             imageView.widthAnchor.constraint(equalToConstant: 22),
             imageView.heightAnchor.constraint(equalToConstant: 22),
             imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
             imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),

             label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
             label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
         ])

         configureSymbol()
         addTarget(self, action: #selector(tapped), for: .touchUpInside)
         updateUI()
     }

     private func configureSymbol() {
         switch style {
         case .star:
             imageView.image = UIImage(systemName: "star")
             label.isHidden = true

         case .heart:
             imageView.image = UIImage(systemName: "heart")
             label.isHidden = true

         case .tick:
             imageView.image = UIImage(systemName: "checkmark")
             label.isHidden = true

         case .emoji:
             let faces = [
                 "face.smiling",
                 "face.smiling.inverse",
                 "face.dashed"
             ]
             imageView.image = UIImage(systemName: faces[min(index, faces.count - 1)])
             label.isHidden = true

         case .buttons:
             label.text = "\(index + 1)"
             imageView.isHidden = true
         }
     }

     private func updateUI() {
         let tint = isSelected ? tintColor : .systemGray3
         imageView.tintColor = tint
         label.textColor = tint
         layer.borderColor = tint?.cgColor
         backgroundColor = isSelected ? tint?.withAlphaComponent(0.1) : .clear
     }

     @objc private func tapped() {
         sendActions(for: .valueChanged)
     }
}

