//
//  FilterViewModel.swift
//  TicketsApp
//
//  Created by test on 02/07/2026.
//
import RxSwift
import RxCocoa

class FilterViewModel {
    let filterOptions = BehaviorRelay(value: [
        FilterOption(label: "All", isSelected: true, isAll: true),
        FilterOption(label: "Closed"),
        FilterOption(label: "Resolved"),
        FilterOption(label: "Progress")
    ])

    let selectedOption = BehaviorRelay<FilterOption?>(value: nil)
    var selectedOptions = BehaviorRelay<[FilterOption]>(value: [])
    let disposeBag = DisposeBag()

    init(alreadySelected: [FilterOption]) {
        selectedOptions
            .subscribe(onNext: {[weak self] opts in
                guard let self else { return }

                let options = self.filterOptions.value

                options.forEach { opt in
                    opt.isSelected = self.selectedOptions.value.contains(where: { $0.label == opt.label })
                }

                filterOptions.accept(options)
            })
            .disposed(by: disposeBag)
        
        selectedOptions.accept(alreadySelected)

        selectedOption
            .subscribe(onNext: { [weak self] tapped in
                guard let self,
                      let tapped else { return }

                var options = self.filterOptions.value
                var selected = self.selectedOptions.value

                guard let index = options.firstIndex(where: { $0.label == tapped.label }) else { return }

                let isAll = options[index].isAll

                if isAll {
                    options = options.map {
                        let copy = $0
                        copy.isSelected = ($0.isAll)
                        return copy
                    }

                    selected.removeAll()
                } else {
                    options[index].isSelected.toggle()
                    if let allIndex = options.firstIndex(where: { $0.isAll }) {
                        options[allIndex].isSelected = false
                    }

                    if options[index].isSelected {
                        selected.append(options[index])
                    } else {
                        selected.removeAll { $0.label == options[index].label }
                    }

                    if selected.isEmpty {
                        if let allIndex = options.firstIndex(where: { $0.isAll }) {
                            options = options.map {
                                let copy = $0
                                copy.isSelected = false
                                return copy
                            }
                            options[allIndex].isSelected = true
                        }
                    }
                }

                self.filterOptions.accept(options)
                self.selectedOptions.accept(selected)
            })
            .disposed(by: disposeBag)
    }
}
