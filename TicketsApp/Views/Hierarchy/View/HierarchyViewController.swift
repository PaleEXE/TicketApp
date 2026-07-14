//
//  HierarchyViewController.swift
//  TicketsApp
//
//  Created by test on 13/07/2026.
//

import UIKit
import RxSwift
import RxCocoa


class HierarchyViewController: AppViewController {
    @IBOutlet weak var profileDetailsView: RoundedView!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        title = "My Hierarchy"
        setupUI()
    }

    func setupUI() {
        let tapGesture = UITapGestureRecognizer()

        profileDetailsView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.pushViewController(ProfileDetailsViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
