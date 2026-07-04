//
//  FilterCollectionViewCell.swift
//  TicketsApp
//
//  Created by test on 02/07/2026.
//

import UIKit
import RxSwift
import RxCocoa

class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var plusImage: UIImageView!

    var disposeBag = DisposeBag()
    var vm : FilterCollectionViewCellModel!

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        roundedView.setNeedsLayout()
        roundedView.layoutIfNeeded()
    }

    func bind(to vm: FilterCollectionViewCellModel) {
        self.vm = vm

        self.vm.label
            .asDriver()
            .drive(filterLabel.rx.text)
            .disposed(by: disposeBag)

        /*self.vm.isSelected
            .map { $0 ? .systemBlue : .lightGray.withAlphaComponent(0.2)}
            .asDriver(onErrorJustReturn: .purple)
            .drive(roundedView.rx.backgroundColor)
            .disposed(by: disposeBag)

        self.vm.isSelected
            .map { $0 ? .bg : .systemGray}
            .asDriver(onErrorJustReturn: .purple)
            .drive(filterLabel.rx.textColor)
            .disposed(by: disposeBag)

        self.vm.isSelected
            .asDriver(onErrorJustReturn: false)
            .drive(plusImage.rx.isHidden)
            .disposed(by: disposeBag)*/

        Observable
            .combineLatest(self.vm.isAll, self.vm.isSelected)
            .subscribe(onNext: {[weak self] isAll, isSelected in
                guard let self else { return }

                let isActive = isSelected

                if isActive {
                    self.roundedView.backgroundColor = .systemBlue
                    self.filterLabel.textColor = .bg
                    self.plusImage.isHidden = true
                } else {
                    self.roundedView.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    self.filterLabel.textColor = .systemGray
                    self.plusImage.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
}
