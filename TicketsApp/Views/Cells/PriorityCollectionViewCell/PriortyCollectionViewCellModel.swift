//
//  PriortiyCollectionViewCellModel.swift
//  TicketsApp
//
//  Created by test on 05/07/2026.
//

import RxSwift
import RxCocoa


class PriorityCollectionViewCellModel {
    let label: BehaviorRelay<String>
    let isSelected: BehaviorRelay<Bool>

    init(model: Priority) {
        self.label = BehaviorRelay(value: model.priority.title)
        self.isSelected = BehaviorRelay(value: model.isSelected)
    }
}
