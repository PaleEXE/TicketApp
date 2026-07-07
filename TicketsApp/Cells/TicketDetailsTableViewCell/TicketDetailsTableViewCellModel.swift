//
//  TicketDetailsTableViewCellModel.swift
//  TicketsApp
//
//  Created by test on 06/07/2026.
//

import RxSwift
import RxCocoa


class TicketDetailsTableViewCellModel {
    let title: BehaviorRelay<String>
    let value: BehaviorRelay<DetailsValue>

    init(title: String, value: DetailsValue) {
        self.title = BehaviorRelay(value: title)
        self.value = BehaviorRelay(value: value)
    }
}
