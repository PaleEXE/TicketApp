import UIKit
import RxSwift
import RxCocoa

class TicketsTotalStatusCellView: UICollectionViewCell {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tagView: UIView!

    private let statusTag = TicketStatusTagView()
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupTagContainer()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        totalLabel.text = nil
    }

    private func setupTagContainer() {
        tagView.backgroundColor = .clear

        statusTag.translatesAutoresizingMaskIntoConstraints = false
        tagView.addSubview(statusTag)

        NSLayoutConstraint.activate([
            statusTag.topAnchor.constraint(equalTo: tagView.topAnchor),
            statusTag.bottomAnchor.constraint(equalTo: tagView.bottomAnchor),
            statusTag.leadingAnchor.constraint(equalTo: tagView.leadingAnchor),
            statusTag.trailingAnchor.constraint(equalTo: tagView.trailingAnchor)
        ])
    }

    func configure(totalDriver: Driver<String>, statusDriver: Driver<TicketStatus>) {

        totalDriver
            .drive(totalLabel.rx.text)
            .disposed(by: disposeBag)

        statusDriver
            .drive(onNext: { [weak self] status in
                self?.statusTag.configure(with: status)
            })
            .disposed(by: disposeBag)
    }
}
