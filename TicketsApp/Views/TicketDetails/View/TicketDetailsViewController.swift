import UIKit
import RxSwift
import RxCocoa

class TicketDetailsViewController: AppViewController {

    init() {
        super.init(nibName: "TicketDetailsViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var detailsCardStack: UIStackView!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var closeTicketButton: UIButton!
    @IBOutlet weak var addCommentButton: UIButton!

    let statusPill = TicketStatusTagView()
    lazy var statusRow = TicketDetailsRowView(customRightView: statusPill)
    let idRow = TicketDetailsRowView()
    let typeRow = TicketDetailsRowView()
    let subTypeRow = TicketDetailsRowView()
    let dateRow = TicketDetailsRowView()
    let priorityRow = TicketDetailsRowView()

    private let disposeBag = DisposeBag()
    var vm: TicketDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "View Details"

        setupDescriptionTextView()
        setupStaticRowTitles()
        layoutCardStack()
    }

    private func setupDescriptionTextView() {
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
    }

    private func setupStaticRowTitles() {
        idRow.titleLabel.text = "Ticket ID"
        dateRow.titleLabel.text = "Date"
        typeRow.titleLabel.text = "Ticket type"
        subTypeRow.titleLabel.text = "Sub type"
        priorityRow.titleLabel.text = "Priority level"
        statusRow.titleLabel.text = "Status"
    }

    private func layoutCardStack() {
        [statusRow, idRow, typeRow, dateRow, priorityRow].forEach { detailsCardStack.addArrangedSubview($0) }

    }

    func bind(to vm: TicketDetailsViewModel) {
        self.vm = vm
        self.loadViewIfNeeded() // i hate ts

        self.vm.id
            .asDriver()
            .drive(self.idRow.valueLabel.rx.text)
            .disposed(by: disposeBag)

        self.vm.date
            .asDriver()
            .drive(self.dateRow.valueLabel.rx.text)
            .disposed(by: disposeBag)

        self.vm.description
            .asDriver()
            .drive(self.descriptionTextView.rx.text)
            .disposed(by: disposeBag)

        self.vm.priority
            .asDriver()
            .map { $0.title }
            .drive(self.priorityRow.valueLabel.rx.text)
            .disposed(by: disposeBag)

        self.vm.type
            .asDriver()
            .drive(self.typeRow.valueLabel.rx.text)
            .disposed(by: disposeBag)

        self.vm.subType
            .asDriver(onErrorJustReturn: "")
            .drive(self.subTypeRow.valueLabel.rx.text)
            .disposed(by: disposeBag)
    
        self.vm.status
            .asDriver()
            .drive(onNext: { [weak self] status in
                self?.statusPill.configure(with: status)
            })
            .disposed(by: disposeBag)
    }
}
