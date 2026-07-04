//
//  FilterOption.swift
//  TicketsApp
//
//  Created by test on 02/07/2026.
//

class FilterOption {
    let label: String
    var isSelected: Bool
    let isAll: Bool

    init(label: String, isSelected: Bool = false, isAll: Bool = false) {
        self.label = label
        self.isSelected = isSelected
        self.isAll = isAll
    }
}
