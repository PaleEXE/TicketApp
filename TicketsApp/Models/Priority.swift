//
//  TicketPriority.swift
//  TicketsApp
//
//  Created by test on 05/07/2026.
//

class Priority {
    let priority: TicketPriority
    var isSelected: Bool

    init(priority: TicketPriority, isSelected: Bool = false) {
        self.priority = priority
        self.isSelected = isSelected
    }
}
