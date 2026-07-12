//
//  TicketDetails.swift
//  TicketsApp
//
//  Created by test on 12/07/2026.
//

class TicketDetails {
    var status: TicketStatus
    let id: String
    let type: String
    let subType: String
    let date: String
    let priorityLevel: TicketPriority

    init(id: String, status: TicketStatus, type: String, subType: String, date: String, priorityLevel: TicketPriority) {
        self.status = status
        self.id = id
        self.type = type
        self.subType = subType
        self.date = date
        self.priorityLevel = priorityLevel
    }
}
