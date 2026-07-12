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
        FilterOption(label: "All", key: "all", isSelected: true),
        FilterOption(label: "Closed", key: TicketStatus.closed.key),
        FilterOption(label: "Resolved", key: TicketStatus.resolved.key),
        FilterOption(label: "Progress", key: TicketStatus.progress.key)
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
                    opt.isSelected = opts.contains(where: { $0 == opt })
                }

                if opts.isEmpty {
                    let index = options.firstIndex(where: { $0.key == "all"})!
                    options[index].isSelected = true
                }

                filterOptions.accept(options)
            })
            .disposed(by: disposeBag)
        
        selectedOptions.accept(alreadySelected)

        selectedOption
            .subscribe(onNext: { [weak self] tapped in
                guard let self,
                      let tapped else { return }

                var selected = self.selectedOptions.value

                if tapped.key == "all" {
                    selected.removeAll()
                } else {
                    selected.removeAll(where: { $0.key == "all" })
                    let opt =  self.filterOptions.value.first(where: { $0 == tapped })
                    opt?.isSelected.toggle()
                    if opt?.isSelected == true {
                        selected.append(opt!)
                    } else if opt?.isSelected == false {
                        selected.removeAll(where: { $0 == opt! })
                    } else {
                        print("NUH UH")
                    }
                }

                self.selectedOptions.accept(selected)
            })
            .disposed(by: disposeBag)
    }

    func clearFilters() {
        self.selectedOptions.accept([])
    }
}
