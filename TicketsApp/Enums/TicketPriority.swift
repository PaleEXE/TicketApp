//
//  TicketPriority.swift
//  TicketsApp
//
//  Created by test on 01/07/2026.
//

enum TicketPriority {
    case low
    case medium
    case high
    case mimi

    var title: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .mimi: return "Mimi"
        }
    }
}
