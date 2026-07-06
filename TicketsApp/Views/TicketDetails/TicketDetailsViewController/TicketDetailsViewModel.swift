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
        self.id = BehaviorRelay(value: model.id)
        self.type = BehaviorRelay(value: model.type)
        self.subType = BehaviorRelay(value: model.subType)
        self.date = BehaviorRelay(value: model.date)
        self.description = BehaviorRelay(value: model.description)
        self.priority = BehaviorRelay(value: model.priority)
        self.status = BehaviorRelay(value: model.status)
    }
}
