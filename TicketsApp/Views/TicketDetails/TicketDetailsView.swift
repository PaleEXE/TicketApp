import UIKit
import RxSwift
import RxCocoa

class TicketDetailsView: AppViewController {

    // MARK: - Outlets
    @IBOutlet weak var detailsCardStack: UIStackView!
    @IBOutlet weak var documentsStack: UIStackView!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var closeTicketButton: UIButton!
    @IBOutlet weak var addCommentButton: UIButton!

    private let disposeBag = DisposeBag()

    // --- NEW: The Injected Data ---
    var ticket: Ticket!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "View Details"

        setupDescriptionTextView()
        populateData() // Now uses the injected 'ticket'
    }

    private func setupDescriptionTextView() {
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
    }

    private func populateData() {
        // Safeguard in case it somehow loads without a ticket
        guard let ticket = ticket else { return }

        // 1. Details Box
        let statusPill = TicketStatusTagView()
        statusPill.configure(with: ticket.status)

        let statusRow = TicketDetailsRowView(customRightView: statusPill)
        statusRow.configure(staticTitle: "Status", valueDriver: .empty())

        let idRow = TicketDetailsRowView()
        idRow.configure(staticTitle: "Ticket ID", valueDriver: .just(ticket.id))

        // Note: Assuming 'type' and 'priority' aren't in your Ticket model yet.
        // I've kept them as static strings for now, but you can swap them to ticket.type easily later.
        let typeRow = TicketDetailsRowView()
        typeRow.configure(staticTitle: "Ticket type", valueDriver: .just("Network issue"))

        let dateRow = TicketDetailsRowView()
        dateRow.configure(staticTitle: "Date", valueDriver: .just(ticket.date))

        let priorityRow = TicketDetailsRowView()
        priorityRow.configure(staticTitle: "Priority level", valueDriver: .just("High"))

        [statusRow, idRow, typeRow, dateRow, priorityRow].forEach { detailsCardStack.addArrangedSubview($0) }
    }

    private func createDocumentRow(fileName: String) -> UIView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 12
        row.alignment = .center

        let icon = UIImageView(image: UIImage(systemName: "doc"))
        icon.tintColor = .lightGray
        icon.setContentHuggingPriority(.required, for: .horizontal)

        let label = UILabel()
        label.text = fileName
        label.font = .systemFont(ofSize: 15, weight: .medium)

        let eyeBtn = UIButton(type: .system)
        eyeBtn.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeBtn.setContentHuggingPriority(.required, for: .horizontal)

        row.addArrangedSubview(icon)
        row.addArrangedSubview(label)
        row.addArrangedSubview(eyeBtn)

        row.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return row
    }
}
