//
//  TicketStatus.swift
//  TicketsApp
//
//  Created by test on 01/07/2026.
//
import UIKit


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

    var key: String {
        switch self {
        case .progress: return "prg"
        case .closed: return "cls"
        case .resolved: return "res"
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
