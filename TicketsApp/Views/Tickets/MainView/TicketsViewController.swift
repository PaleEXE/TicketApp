import UIKit
import RxSwift
import RxCocoa

class TicketsViewController: AppViewController {

    @IBOutlet weak var ticketsTotalStatus: UICollectionView!
    @IBOutlet weak var ticketsTabelView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var newTicketButton: UIButton!
    @IBOutlet weak var selectedFiltersCollectionView: UICollectionView!
    @IBOutlet weak var selectedFiltersView: UIView!

    private let vm = TicketsViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tickets"
        setupUI()

        vm.fetchDummyData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureTicketsTotalStatusCollectionViewLayout()
    }

    private func setupUI() {
        setupCollectionView()
        setupTableView()
        setupNewTicketButton()
        setupBindings()
    }

    private func setupCollectionView() {
        ticketsTotalStatus.showsHorizontalScrollIndicator = false
        ticketsTotalStatus.backgroundColor = .clear

        ticketsTotalStatus.register(
            UINib(nibName: "TicketsTotalStatusCellView", bundle: nil),
            forCellWithReuseIdentifier: "TicketsTotalStatusCellView"
        )

        selectedFiltersCollectionView.showsHorizontalScrollIndicator = false
        selectedFiltersCollectionView.backgroundColor = .clear

        selectedFiltersCollectionView.register(
            UINib(nibName: "FilterCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "FilterCollectionViewCell"
        )
    }

    private func setupTableView() {
        ticketsTabelView.backgroundColor = .clear
        ticketsTabelView.separatorStyle = .none
        ticketsTabelView.rowHeight = UITableView.automaticDimension
        ticketsTabelView.estimatedRowHeight = 100

        ticketsTabelView.register(
            UINib(nibName: "TicketTableViewCell", bundle: nil),
            forCellReuseIdentifier: "TicketTableViewCell"
        )
    }

    private func setupNewTicketButton() {
        newTicketButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.pushViewController(NewTicketViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupBindings() {
        bindSelectedFilters()
        bindTicketsTotalStatusCollectionView()
        bindTicketsTableView()

        filterButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.presentFilterSheet()
            })
            .disposed(by: disposeBag)

        ticketsTabelView.rx.modelSelected(Ticket.self)
            .asDriver()
            .drive(onNext: { [weak self] selectedTicket in
                self?.navigateToTicketDetails(with: selectedTicket)
            })
            .disposed(by: disposeBag)

        ticketsTabelView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                self?.ticketsTabelView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
    private func navigateToTicketDetails(with ticket: Ticket) {
        let detailsVC = TicketDetailsView()
        detailsVC.bind(to: TicketDetailsViewModel(model: ticket))
        navigationController?.pushViewController(detailsVC, animated: true)
    }

    private func presentFilterSheet() {
        let filterVC = FilterViewController(alreadySelected: vm.selectedFilterOptions.value)

        if let sheet = filterVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }

        present(filterVC, animated: true)

        filterVC.applyTapped
            .bind(to: self.vm.selectedFilterOptions)
            .disposed(by: disposeBag)
    }

    private func bindSelectedFilters() {
        guard let layout = selectedFiltersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        layout.itemSize = CGSize(
            width:  layout.itemSize.width,
            height: selectedFiltersCollectionView.bounds.height,
        )
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        layout.invalidateLayout()

        selectedFiltersCollectionView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)

        vm.selectedFilterOptions
            .asDriver()
            .drive(selectedFiltersCollectionView.rx.items(
                cellIdentifier: "FilterCollectionViewCell",
                cellType: FilterCollectionViewCell.self
            )) { _, opt, cell in
                let vm = FilterCollectionViewCellModel(model: opt)
                cell.bind(to: vm)
            }
            .disposed(by: disposeBag)

        vm.selectedFilterOptions
            .map { $0.isEmpty }
            .asDriver(onErrorJustReturn: true)
            .drive(selectedFiltersView.rx.isHidden)
            .disposed(by: disposeBag)

        selectedFiltersCollectionView.rx
            .modelSelected(FilterOption.self)
            .subscribe(onNext: { tappedOpt in
                var opts = self.vm.selectedFilterOptions.value
                opts.removeAll(where: { $0.label == tappedOpt.label })
                self.vm.selectedFilterOptions.accept(opts)
            })
            .disposed(by: disposeBag)
    }

    private func bindTicketsTotalStatusCollectionView() {
        vm.summaries
            .asDriver()
            .drive(ticketsTotalStatus.rx.items(
                cellIdentifier: "TicketsTotalStatusCellView",
                cellType: TicketsTotalStatusCellView.self
            )) { _, summary, cell in
                let countDriver = Driver.just(summary.count)
                let statusDriver = Driver.just(summary.status)

                cell.configure(totalDriver: countDriver, statusDriver: statusDriver)
            }
            .disposed(by: disposeBag)
    }

    private func bindTicketsTableView() {
        vm.tickets
            .asDriver()
            .drive(ticketsTabelView.rx.items(
                cellIdentifier: "TicketTableViewCell",
                cellType: TicketTableViewCell.self
            )) { _, ticket, cell in
                let ticketDriver = Driver.just(ticket)
                cell.configure(ticketDriver: ticketDriver)

            }
            .disposed(by: disposeBag)
        }

    private func configureTicketsTotalStatusCollectionViewLayout() {
        guard let layout = ticketsTotalStatus.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let numberOfVisibleCells: CGFloat = 3
        let spacing: CGFloat = 12
        let horizontalMargin: CGFloat = 16

        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: horizontalMargin, bottom: 0, right: horizontalMargin)

        let totalGaps = spacing * (numberOfVisibleCells - 1)
        let totalMargins = horizontalMargin * 2
        let availableWidth = ticketsTotalStatus.bounds.width - totalMargins - totalGaps

        let cellWidth = floor(availableWidth / numberOfVisibleCells)

        layout.itemSize = CGSize(width: cellWidth, height: ticketsTotalStatus.bounds.height)
    }
}


extension TicketsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let options = vm.selectedFilterOptions.value
        guard indexPath.row < options.count else { return .zero }

        let text = options[indexPath.row].label

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
