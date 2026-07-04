//
//  RoundedView.swift
//  TicketsApp
//
//  Created by test on 01/07/2026.
//

import UIKit


@IBDesignable class RoundedView: UIView {
    @IBInspectable var isRounded: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        if isRounded {
            layer.cornerRadius = bounds.height / 2
            layer.cornerCurve = .continuous
            layer.masksToBounds = true
            clipsToBounds = true
        }
    }
}
