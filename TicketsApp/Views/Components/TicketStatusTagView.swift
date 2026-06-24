//
//  TicketStatusTagView.swift
//  TicketsApp
//
//  Created by test on 24/06/2026.
//

import UIKit

// 1. Define the specific statuses from your design
enum TicketStatus {
    case progress
    case closed
    case resolved

    var title: String {
        switch self {
        case .progress: return "Progress"
        case .closed: return "Closed"
        case .resolved: return "Resolved"
        }
    }

    var textColor: UIColor {
        switch self {
        case .progress: return UIColor.systemOrange
        case .closed: return UIColor.systemRed
        case .resolved: return UIColor.systemGreen
        }
    }

    var backgroundColor: UIColor {
        return textColor.withAlphaComponent(0.15)
    }
}

class TicketStatusTagView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }

    func configure(with status: TicketStatus) {
        titleLabel.text = status.title
        titleLabel.textColor = status.textColor
        self.backgroundColor = status.backgroundColor
    }
}
