//
//  Ticket.swift
//  TicketsApp
//
//  Created by test on 24/06/2026.
//


struct Ticket {
    var details: TicketDetails
    let description: String

    init(id: String, type: String, subType: String = "sui", date: String, description: String = "idk", priorityLevel: TicketPriority, status: TicketStatus) {
        self.details = TicketDetails(id: id,status: status, type: type, subType: subType, date: date, priorityLevel: priorityLevel)
        self.description = description
    }
}
