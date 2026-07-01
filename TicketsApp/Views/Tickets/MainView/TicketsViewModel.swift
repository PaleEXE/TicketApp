//
//  TicketsViewModel.swift
//  TicketsApp
//
//  Created by test on 24/06/2026.
//

import Foundation
import RxSwift
import RxCocoa

struct TicketSummary {
    let count: String
    let status: TicketStatus
}

// MARK: - ViewModel

class TicketsViewModel {

    // Relays for our views to bind to
    let summaries = BehaviorRelay<[TicketSummary]>(value: [])
    let tickets = BehaviorRelay<[Ticket]>(value: [])

    func fetchDummyData() {

        let dummySummaries = [
            TicketSummary(count: "100", status: .progress),
            TicketSummary(count: "50", status: .closed),
            TicketSummary(count: "20", status: .resolved)
        ]

        let dummyTickets = [
            Ticket(id: "2004", title: "Network issue", date: "24 Jun 2026", status: .progress),
            Ticket(id: "2005", title: "Skill issue", date: "23 Jun 2026", status: .resolved),
            Ticket(id: "2006", title: "Trust issue", date: "21 Jun 2026", status: .progress),
            Ticket(id: "2007", title: "Famely issue", date: "18 Jun 2026", status: .closed),
            Ticket(id: "2008", title: "Angar issue", date: "15 Jun 2026", status: .closed),
            Ticket(id: "2010", title: "IDK issue", date: "10 Jun 2026", status: .resolved)
        ]

        // Emit the dummy data
        summaries.accept(dummySummaries)
        tickets.accept(dummyTickets)
    }
}
