//
//  FilterCollectionViewCellModel.swift
//  TicketsApp
//
//  Created by test on 02/07/2026.
//
import RxSwift
import RxCocoa

class FilterCollectionViewCellModel {
    let label: BehaviorRelay<String>
    let isSelected: BehaviorRelay<Bool>

    init(model: FilterOption) {
        label = BehaviorRelay(value: model.label)
        isSelected = BehaviorRelay(value: model.isSelected)
    }
}
