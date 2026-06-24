import UIKit
import RxSwift
import RxCocoa

class TicketsViewController: UIViewController {

    @IBOutlet weak var ticketsTotalStatus: UICollectionView!
    @IBOutlet weak var ticketsTabelView: UITableView!

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

    private func setupBindings() {
        bindTicketsTotalStatusCollectionView()
        bindTicketsTableView()
    }

    private func bindTicketsTotalStatusCollectionView() {
        viewModel.summaries.asDriver()
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
            viewModel.tickets.asDriver()
                .drive(ticketsTabelView.rx.items(
                    cellIdentifier: "TicketTableViewCell",
                    cellType: TicketTableViewCell.self
                )) { _, ticket, cell in

                    // Wrap the individual ticket into a Driver to pass to the cell
                    let ticketDriver = Driver.just(ticket)
                    cell.configure(ticketDriver: ticketDriver)

                }
                .disposed(by: disposeBag)
        }

    // MARK: - Layout Configuration

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
