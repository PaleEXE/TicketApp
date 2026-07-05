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
        "Network",
        "skill",
        "idk",
        "sui"
    ])
    let selectedTicketType: BehaviorRelay<String?> = BehaviorRelay(value: nil)

    let ticketSubTypes = BehaviorRelay(value: [
        "Fast",
        "not"
    ])
    let selectedSubTicketType: BehaviorRelay<String?> = BehaviorRelay(value: nil)

    let priorities = BehaviorRelay(value: [
        Priority(priority: .low),
        Priority(priority: .medium),
        Priority(priority: .high),
        Priority(priority: .mimi),
    ])
    let selectedPriority: BehaviorRelay<Priority?> = BehaviorRelay(value: nil)

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
