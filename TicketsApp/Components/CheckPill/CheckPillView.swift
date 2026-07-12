import UIKit

@IBDesignable
class CheckPillView: UIView {

    @IBInspectable var withCheckMark: Bool = true {
        didSet {
            checkMarkImageView?.isHidden = !withCheckMark
        }
    }

    @IBInspectable var customBgColor: UIColor = UIColor(red: 0.85, green: 0.91, blue: 0.96, alpha: 1.0) {
        didSet { updateTheme() }
    }

    @IBInspectable var customBorderColor: UIColor = .systemBlue {
        didSet { updateTheme() }
    }

    @IBInspectable var customTextColor: UIColor = .systemBlue {
        didSet { updateTheme() }
    }

    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    private var isDoneState: Bool = false

    override func awakeAfter(using coder: NSCoder) -> Any? {
        if subviews.isEmpty {
            let bundle = Bundle(for: type(of: self))
            guard let realView = UINib(nibName: "CheckPillView", bundle: bundle).instantiate(withOwner: nil, options: nil).first as? CheckPillView else {
                return super.awakeAfter(using: coder)
            }

            realView.frame = self.frame
            realView.autoresizingMask = self.autoresizingMask
            realView.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints

            realView.withCheckMark = self.withCheckMark
            realView.customBgColor = self.customBgColor
            realView.customBorderColor = self.customBorderColor
            realView.customTextColor = self.customTextColor

            return realView
        }
        return super.awakeAfter(using: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 12
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        updateTheme()
    }

    func configure(isDone: Bool, text: String) {
        titleLabel.text = text
        self.isDoneState = isDone
        updateTheme()
    }

    private func updateTheme() {
        if isDoneState {
            backgroundColor = UIColor(red: 0.85, green: 0.96, blue: 0.87, alpha: 1.0)
            titleLabel?.textColor = .systemGreen
            checkMarkImageView?.tintColor = .systemGreen
            layer.borderColor = UIColor.systemGreen.cgColor
        } else {
            backgroundColor = customBgColor
            titleLabel?.textColor = customTextColor
            checkMarkImageView?.tintColor = customTextColor
            layer.borderColor = customBorderColor.cgColor
        }
    }
}
