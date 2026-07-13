//
//  RoundedView.swift
//  TicketsApp
//
//  Created by test on 01/07/2026.
//

import UIKit


@IBDesignable class RoundedView: UIView {
    @IBInspectable var isMasksToBounds: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var isRounded: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = .white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if isRounded {
            layer.cornerRadius = bounds.height / 2
            layer.cornerCurve = .continuous
            layer.masksToBounds = isMasksToBounds
            clipsToBounds = isMasksToBounds
        }
    }
}
