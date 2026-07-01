import UIKit
import RxSwift
import RxCocoa

class TicketsViewController: AppViewController {

    @IBOutlet weak var ticketsTotalStatus: UICollectionView!
    @IBOutlet weak var ticketsTabelView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var newTicketButton: PlusButton!

    private let viewModel = TicketsViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tickets"
        setupUI()

        viewModel.fetchDummyData()
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
        newTicketButton.configure(title: "New Ticket")
    }

    private func setupBindings() {
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
        let detailsVC = TicketDetailsView(nibName: "TicketDetailsView", bundle: nil)
        detailsVC.ticket = ticket
        navigationController?.pushViewController(detailsVC, animated: true)
    }

    private func presentFilterSheet() {
        let filterVC = FilterViewController()

        if let sheet = filterVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }

        present(filterVC, animated: true)
    }

    private func bindTicketsTotalStatusCollectionView() {
        viewModel.summaries
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
        viewModel.tickets
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
