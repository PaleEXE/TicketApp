//
//  Untitled.swift
//  TicketsApp
//
//  Created by test on 25/06/2026.
//

import UIKit
import RxSwift
import RxCocoa

class TicketDetailsRowView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()

    var customRightView: UIView = UIView()

    private let spacerView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    convenience init(customRightView: UIView) {
        self.init(frame: .zero)
        self.customRightView = customRightView
        valueLabel.isHidden = true
        stackView.addArrangedSubview(customRightView)
    }

    private func setupView() {
        backgroundColor = .white

        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(spacerView)
        stackView.addArrangedSubview(valueLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    func configure(titleDriver: Driver<String>, valueDriver: Driver<String>) {
        titleDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)

        valueDriver
            .drive(valueLabel.rx.text)
            .disposed(by: disposeBag)
    }

    func configure(staticTitle: String, valueDriver: Driver<String>) {
        titleLabel.text = staticTitle

        valueDriver
            .drive(valueLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
