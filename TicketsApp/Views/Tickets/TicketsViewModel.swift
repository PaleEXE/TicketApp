import Foundation
import RxSwift
import RxCocoa

class TicketsViewModel {
    let disposeBag = DisposeBag()
    let tickets = BehaviorRelay(value: [
        Ticket(id: "2004", type: "Network issue", date: "24 Jun 2026", priorityLevel: .low, status: .progress),
        Ticket(id: "2005", type: "Skill issue", date: "23 Jun 2026", description: "I hate me", priorityLevel: .high, status: .resolved),
        Ticket(id: "2006", type: "Trust issue", date: "21 Jun 2026", priorityLevel: .medium, status: .progress),
        Ticket(id: "2009", type: "Sui issue", date: "21 Jun 2026", priorityLevel: .medium, status: .closed),
        Ticket(id: "2007", type: "Famely issue", date: "18 Jun 2026", priorityLevel: .mimi, status: .closed),
        Ticket(id: "2008", type: "Angar issue", date: "15 Jun 2026", priorityLevel: .mimi, status: .closed),
        Ticket(id: "2010", type: "IDK issue", date: "10 Jun 2026", priorityLevel: .low, status: .resolved)
    ])

    let summaries = BehaviorRelay<[TicketSummary]>(value: [])
    let filteredTickets = BehaviorRelay<[Ticket]>(value: [])
    let selectedFilterOptions = BehaviorRelay<[FilterOption]>(value: [])
    let selectedTicket = BehaviorRelay<Ticket?>(value: nil)

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

        selectedTicket.subscribe(onNext: { [weak self] tic in
            guard let self else { return }
            guard let tic else { return }
            self.updateTicket(tic)
        })
        .disposed(by: disposeBag)
    }

    func updateTicket(_ updatedTicket: Ticket) {
        var currentTickets = tickets.value
        if let index = currentTickets.firstIndex(where: { $0.details.id == updatedTicket.details.id }) {
            currentTickets[index] = updatedTicket
            tickets.accept(currentTickets)
        }
    }

    func calculateSummaries() {
        var summaries: [TicketStatus: Int] = [:]

        tickets.value.forEach { tic in
            summaries[tic.details.status, default: 0] += 1
        }

        let finalSummaries = summaries.map { TicketSummary(count: "\($0.value)", status: $0.key) }
        self.summaries.accept(finalSummaries)
    }

    private func filterAndAccept() {
        let filterKeys = selectedFilterOptions.value.map { $0.key }

        let filteredTickets = filterKeys.isEmpty ? self.tickets.value : self.tickets.value.filter { tic in
            filterKeys.contains(tic.details.status.key)
        }

        self.filteredTickets.accept(filteredTickets)
    }

    func getObservableValues() -> Observable<[TicketDetailsTableViewCellModel]> {
        return selectedTicket
            .compactMap { $0 }
            .map { ticket -> [TicketDetailsTableViewCellModel] in
                var models = Mirror(reflecting: ticket.details).children
                    .compactMap { child in
                        let label = child.label ?? "ERR"
                        let val: DetailsValue = {
                            if let status = child.value as? TicketStatus {
                                return .status(status)
                            } else {
                                return .normal("\(child.value)")
                            }
                        }()
                        return TicketDetailsTableViewCellModel(title: label.fromCamelToTitle(), value: val)
                    }

                if let idx = models.firstIndex(where: {
                    if case .status = $0.value.value { return true }
                    return false
                }) {
                    models.swapAt(0, idx)
                }

                return models
            }
    }
}
