//
//  IntrinsicTableView.swift
//  TicketsApp
//
//  Created by test on 07/07/2026.
//


import UIKit

class IntrinsicTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)    }
}
