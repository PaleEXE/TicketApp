import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var pillsStackView: UIStackView!
    @IBOutlet weak var checkInPill: CheckPillView!
    @IBOutlet weak var checkOutPill: CheckPillView!
    @IBOutlet weak var statusPill: CheckPillView!
    @IBOutlet weak var checkOutButton: RoundedButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupFlexiblePillsLayout()
        statusPill.titleLabel.text = "Not Completed"
    }

    private func setupFlexiblePillsLayout() {
        pillsStackView.distribution = .fill
        pillsStackView.alignment = .fill
        pillsStackView.spacing = 8

        checkInPill.setContentHuggingPriority(.required, for: .horizontal)
        checkInPill.setContentCompressionResistancePriority(.required, for: .horizontal)

        checkOutPill.setContentHuggingPriority(.required, for: .horizontal)
        checkOutPill.setContentCompressionResistancePriority(.required, for: .horizontal)

        let trailingSpacer = UIView()
        trailingSpacer.backgroundColor = .clear
        trailingSpacer.translatesAutoresizingMaskIntoConstraints = false
        trailingSpacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        pillsStackView.addArrangedSubview(trailingSpacer)
    }
}
