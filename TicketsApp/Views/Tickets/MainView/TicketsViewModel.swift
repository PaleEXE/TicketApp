import Foundation
import RxSwift
import RxCocoa

class TicketsViewModel {
    let disposeBag = DisposeBag()
    let dummyTickets = [
        Ticket(id: "2004", title: "Network issue", date: "24 Jun 2026", priority: .low, status: .progress),
        Ticket(id: "2005", title: "Skill issue", date: "23 Jun 2026", description: "I hate me", priority: .high, status: .resolved),
        Ticket(id: "2006", title: "Trust issue", date: "21 Jun 2026", priority: .medium, status: .progress),
        Ticket(id: "2007", title: "Famely issue", date: "18 Jun 2026", priority: .mimi, status: .closed),
        Ticket(id: "2008", title: "Angar issue", date: "15 Jun 2026", priority: .mimi, status: .closed),
        Ticket(id: "2010", title: "IDK issue", date: "10 Jun 2026", priority: .low, status: .resolved)
    ]

    let summaries = BehaviorRelay<[TicketSummary]>(value: [])
    let tickets = BehaviorRelay<[Ticket]>(value: [])
    let selectedFilterOptions = BehaviorRelay<[FilterOption]>(value: [])

    init() {
        selectedFilterOptions.subscribe(onNext: { opts in
            let filterKeys = opts.map { $0.key }

            let filteredTickets = filterKeys.isEmpty ? self.dummyTickets : self.dummyTickets.filter { tic in
                filterKeys.contains(tic.status.key)
            }

            self.tickets.accept(filteredTickets)
        })
        .disposed(by: disposeBag)
    }
    func fetchDummyData() {
        let dummySummaries = [
            TicketSummary(count: "100", status: .progress),
            TicketSummary(count: "50", status: .closed),
            TicketSummary(count: "20", status: .resolved)
        ]

        summaries.accept(dummySummaries)
        tickets.accept(dummyTickets)
    }
}
