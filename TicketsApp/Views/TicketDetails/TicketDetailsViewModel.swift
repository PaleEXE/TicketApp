//
//  TicketDetailsViewModel.swift
//  TicketsApp
//
//  Created by test on 01/07/2026.
//

import RxSwift
import RxCocoa


class TicketDetailsViewModel {
    let id: BehaviorRelay<String>
    let type: BehaviorRelay<String>
    let subType: BehaviorRelay<String>
    let date: BehaviorRelay<String>
    let description: BehaviorRelay<String>
    let priority: BehaviorRelay<TicketPriority>
    let status: BehaviorRelay<TicketStatus>

    init(model: Ticket) {
        self.id = BehaviorRelay(value: model.details.id)
        self.type = BehaviorRelay(value: model.details.type)
        self.subType = BehaviorRelay(value: model.details.subType)
        self.date = BehaviorRelay(value: model.details.date)
        self.description = BehaviorRelay(value: model.description)
        self.priority = BehaviorRelay(value: model.details.priorityLevel)
        self.status = BehaviorRelay(value: model.details.status)
    }
}
