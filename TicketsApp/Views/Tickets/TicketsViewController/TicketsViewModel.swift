import Foundation
import RxSwift
import RxCocoa

class TicketsViewModel {
    let disposeBag = DisposeBag()
    let tickets = BehaviorRelay(value: [
        Ticket(id: "2004", type: "Network issue", date: "24 Jun 2026", priority: .low, status: .progress),
        Ticket(id: "2005", type: "Skill issue", date: "23 Jun 2026", description: "I hate me", priority: .high, status: .resolved),
        Ticket(id: "2006", type: "Trust issue", date: "21 Jun 2026", priority: .medium, status: .progress),
        Ticket(id: "2007", type: "Famely issue", date: "18 Jun 2026", priority: .mimi, status: .closed),
        Ticket(id: "2008", type: "Angar issue", date: "15 Jun 2026", priority: .mimi, status: .closed),
        Ticket(id: "2010", type: "IDK issue", date: "10 Jun 2026", priority: .low, status: .resolved)
    ])

    let summaries = BehaviorRelay<[TicketSummary]>(value: [])
    let filteredTickets = BehaviorRelay<[Ticket]>(value: [])
    let selectedFilterOptions = BehaviorRelay<[FilterOption]>(value: [])

    init() {
        tickets.subscribe(onNext: {tickets in
            self.filterAndAccept()
            self.calculateSummaries()
        })
        .disposed(by: disposeBag)

        selectedFilterOptions.subscribe(onNext: { opts in
            self.filterAndAccept()
        })
        .disposed(by: disposeBag)
    }

    func calculateSummaries() {
        var summaries: [TicketStatus: Int] = [:]

        tickets.value.forEach { tic in
            summaries[tic.status, default: 0] += 1
        }

        let finalSummaries = summaries.map { TicketSummary(count: "\($0.value)", status: $0.key) }
        self.summaries.accept(finalSummaries)
    }

    private func filterAndAccept() {
        let filterKeys = selectedFilterOptions.value.map { $0.key }

        let filteredTickets = filterKeys.isEmpty ? self.tickets.value : self.tickets.value.filter { tic in
            filterKeys.contains(tic.status.key)
        }

        self.filteredTickets.accept(filteredTickets)
    }


    func fetchDummyData() {
        filteredTickets.accept(tickets.value)
    }
}
