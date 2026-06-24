import UIKit
import RxSwift
import RxCocoa

final class TicketTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var leftIndicatorView: UIView!

    @IBOutlet weak var ticketIdLabel: UILabel!
    @IBOutlet weak var issueLabel: UILabel! // Added missing outlet
    @IBOutlet weak var dateLabel: UILabel!

    // Changed from UIView to TicketStatusTagView
    @IBOutlet weak var statusTagView: TicketStatusTagView!

    // 1. Add the DisposeBag
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        backgroundColor = .clear

        containerView?.layer.cornerRadius = 12
        containerView?.clipsToBounds = true

        leftIndicatorView?.layer.cornerRadius = 2
        leftIndicatorView?.backgroundColor = .systemBlue
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        ticketIdLabel.text = nil
        issueLabel?.text = nil
        dateLabel.text = nil
    }

    func configure(ticketDriver: Driver<Ticket>) {

        ticketDriver
            .map { $0.id }
            .drive(ticketIdLabel.rx.text)
            .disposed(by: disposeBag)

        ticketDriver
            .map { $0.issueType }
            .drive(onNext: { [weak self] title in
                self?.issueLabel?.text = title
            })
            .disposed(by: disposeBag)

        ticketDriver
            .map { $0.date }
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)

        ticketDriver
            .map { $0.status }
            .drive(onNext: { [weak self] status in
                self?.statusTagView.configure(with: status)
            })
            .disposed(by: disposeBag)
    }
}
