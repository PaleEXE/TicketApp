//
//  NewTicketViewControllerModel.swift
//  TicketsApp
//
//  Created by test on 05/07/2026.
//

import RxSwift
import RxCocoa


class NewTicketViewModel {
    let disposeBag = DisposeBag()

    let ticketTypes = BehaviorRelay(value: [
        "Hardware Support",
        "Software",
        "Network",
        "Access",
        "Security"
    ])
    let selectedTicketType: BehaviorRelay<String?> = BehaviorRelay(value: nil)

    let ticketSubTypes = BehaviorRelay(value: [
        "Equipment Malfunction",
        "Permission Request",
        "Software Installation Failure",
        "Password Reset",
        "Slow Connection / Outage"
    ])
    let selectedTicketSubType: BehaviorRelay<String?> = BehaviorRelay(value: nil)

    let priorities = BehaviorRelay(value: [
        Priority(priority: .low),
        Priority(priority: .medium),
        Priority(priority: .high),
        Priority(priority: .mimi),
    ])
    let selectedPriority: BehaviorRelay<Priority?> = BehaviorRelay(value: nil)

    let description = BehaviorRelay(value: "")

    init() {
        selectedPriority.subscribe(onNext: {pri in
            self.priorities.value.forEach { priority in
                priority.isSelected = false
            }
            pri?.isSelected = true
            self.priorities.accept(self.priorities.value)
        })
        .disposed(by: disposeBag)
    }
}
