//
//  FilterOption.swift
//  TicketsApp
//
//  Created by test on 02/07/2026.
//

class FilterOption: Equatable {
    let label: String
    let key: String
    var isSelected: Bool

    init(label: String, key: String, isSelected: Bool = false) {
        self.label = label
        self.key = key
        self.isSelected = isSelected
    }

    static func == (lhs: FilterOption, rhs: FilterOption) -> Bool {
        return lhs.key == rhs.key
    }
}
