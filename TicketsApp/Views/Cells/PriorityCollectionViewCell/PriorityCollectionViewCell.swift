//
//  PriorityCollectionViewCell.swift
//  TicketsApp
//
//  Created by test on 05/07/2026.
//

import UIKit
import RxSwift
import RxCocoa


class PriorityCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var priortyLabel: UILabel!

    var vm: PriorityCollectionViewCellModel!
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        roundedView.setNeedsLayout()
        roundedView.layoutIfNeeded()
    }

    func bind(to vm: PriorityCollectionViewCellModel) {
        self.vm = vm

        self.vm.label
            .asDriver()
            .drive(self.priortyLabel.rx.text)
            .disposed(by: disposeBag)

        self.vm.isSelected
            .map { $0 ? .systemBlue : .clear}
            .asDriver(onErrorJustReturn: .purple)
            .drive(self.roundedView.rx.backgroundColor)
            .disposed(by: disposeBag)

        self.vm.isSelected
            .map { $0 ? .bg : .systemBlue}
            .asDriver(onErrorJustReturn: .purple)
            .drive(self.priortyLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
}
