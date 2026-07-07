//
//  PickerTextField.swift
//  TicketsApp
//
//  Created by test on 05/07/2026.
//


import UIKit

class PickerTextField: UITextField {

    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 40)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        clipsToBounds = true
        borderStyle = .none
        tintColor = .clear
        
        rightView = chevronImageView
        rightViewMode = .always
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 16
        return rect
    }
}