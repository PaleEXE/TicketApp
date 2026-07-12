import UIKit
import RxSwift
import RxCocoa

class TicketDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueView: UIView!
    @IBOutlet weak var titleLable: UILabel!

    var vm: TicketDetailsTableViewCellModel! = nil
    let disposeBag = DisposeBag()

    private var activeStatusPill: TicketStatusTagView?

    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyles()
    }

    private func applyStyles() {
        selectionStyle = .none
        backgroundColor = .systemBackground

        titleLable.font = .systemFont(ofSize: 15, weight: .regular)

        valueLabel.font = .systemFont(ofSize: 15, weight: .medium)
        valueLabel.textColor = .label
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        valueLabel.isHidden = false
        activeStatusPill?.removeFromSuperview()
        activeStatusPill = nil
    }

    func bind(to vm: TicketDetailsTableViewCellModel) {
        self.vm = vm

        self.vm.title
            .asDriver(onErrorJustReturn: "—")
            .drive(titleLable.rx.text)
            .disposed(by: disposeBag)

        self.vm.value
            .asDriver(onErrorJustReturn: DetailsValue.normal("—"))
            .drive(onNext: { [weak self] val in
                guard let self = self else { return }

                switch val {
                case .normal(let txt):
                    self.valueLabel.isHidden = false
                    self.valueLabel.text = txt
                    self.activeStatusPill?.removeFromSuperview()

                case .status(let status):
                    self.valueLabel.isHidden = true
                    self.activeStatusPill?.removeFromSuperview()

                    let pill = TicketStatusTagView()
                    pill.configure(with: status)
                    self.valueView.addSubview(pill)
                    self.activeStatusPill = pill

                    pill.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        pill.centerYAnchor.constraint(equalTo: self.valueView.centerYAnchor),
                        pill.trailingAnchor.constraint(equalTo: self.valueView.trailingAnchor, constant: -20),
                        pill.topAnchor.constraint(greaterThanOrEqualTo: self.valueView.topAnchor, constant: 6),
                        pill.bottomAnchor.constraint(lessThanOrEqualTo: self.valueView.bottomAnchor, constant: -6)
                    ])
                }
            })
            .disposed(by: disposeBag)
    }
}
