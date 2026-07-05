//
//  NewTicketViewController.swift
//  TicketsApp
//
//  Created by test on 04/07/2026.
//

import UIKit
import RxSwift
import RxCocoa


class NewTicketViewController: AppViewController {

    @IBOutlet weak var ticketTypeSelector: UIButton!
    @IBOutlet weak var ticketSubTypeSelector: UIButton!
    @IBOutlet weak var priorityCollectionView: UICollectionView!

    let vm = NewTicketViewModel()
    let disposeBag = DisposeBag()

    init() {
        super.init(nibName: "NewTicketViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Ticket"
        setupUI()
    }

    func setupUI() {
        setupTicketTypeSelector(menuButton: ticketTypeSelector, menuOptions: vm.ticketTypes.value)
        setupTicketTypeSelector(menuButton: ticketSubTypeSelector, menuOptions: vm.ticketSubTypes.value)
        setupPriorityCollectionView()
    }

    func setupTicketTypeSelector(menuButton: UIButton, menuOptions: [String]) {

        let actions = menuOptions.map { option in
            UIAction(title: option) { action in
                print("Selected target filter: \(action.title)")
            }
        }
        menuButton.menu = UIMenu(children: actions)

        menuButton.showsMenuAsPrimaryAction = true
        menuButton.changesSelectionAsPrimaryAction = true

        if var config = menuButton.configuration {
            config.image = UIImage(systemName: "chevron.down")
            config.imagePlacement = .trailing
            config.imagePadding = 8
        }
    }

    func setupPriorityCollectionView() {
        guard let layout = priorityCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        layout.itemSize = CGSize(
            width:  layout.itemSize.width,
            height: priorityCollectionView.bounds.height,
        )
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        layout.invalidateLayout()

        priorityCollectionView.showsHorizontalScrollIndicator = false

        priorityCollectionView
            .register(UINib(nibName: "PriorityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PriorityCollectionViewCell")

        priorityCollectionView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)

        vm.priorities
            .bind(to: priorityCollectionView.rx.items(
                cellIdentifier: "PriorityCollectionViewCell",
                cellType: PriorityCollectionViewCell.self
            )) { _, pri, cell in
                let vm = PriorityCollectionViewCellModel(model: pri)
                cell.bind(to: vm)
            }
            .disposed(by: disposeBag)

        priorityCollectionView.rx
            .modelSelected(Priority.self)
            .subscribe(onNext: { [weak self] tappedPriority in
                guard let self else { return }
                self.vm.selectedPriority.accept(tappedPriority)
            })
            .disposed(by: disposeBag)
    }
}

extension NewTicketViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let priorities = vm.priorities.value
        guard indexPath.row < priorities.count else { return .zero }

        let text = priorities[indexPath.row].priority.title

        let font = UIFont.systemFont(ofSize: 17)
        let textAttributes = [NSAttributedString.Key.font: font]

        let maxExpectedSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: collectionView.bounds.height)

        let textWidth = text.boundingRect(
            with: maxExpectedSize,
            options: [.usesLineFragmentOrigin],
            attributes: textAttributes,
            context: nil
        ).width

        let leftRightEdgePadding: CGFloat = 24
        let imageWidth: CGFloat = 20.33
        let stackSpacing: CGFloat = 6

        let totalComputedWidth = ceil(textWidth + leftRightEdgePadding + imageWidth + stackSpacing)

        return CGSize(width: totalComputedWidth, height: collectionView.bounds.height)
    }
}
