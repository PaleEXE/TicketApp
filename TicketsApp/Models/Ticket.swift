//
//  Ticket.swift
//  TicketsApp
//
//  Created by test on 24/06/2026.
//


struct Ticket {
    let id: String
    let title: String
    let date: String
    let description: String
    let priority: TicketPriority
    let status: TicketStatus

    init(id: String, title: String, date: String, description: String = "idk", priority: TicketPriority, status: TicketStatus) {
        self.id = id
        self.title = title
        self.date = date
        self.description = description
        self.priority = priority
        self.status = status
    }
}
