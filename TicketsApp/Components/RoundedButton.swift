import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = -1 {
        didSet {
            applyCornerRadius()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        applyCornerRadius()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyCornerRadius()
    }

    private func applyCornerRadius() {
        if #available(iOS 15.0, *), var config = configuration {
            config.cornerStyle = .fixed
            if cornerRadius < 0 {
                config.background.cornerRadius = min(bounds.width, bounds.height) / 2
            } else {
                config.background.cornerRadius = min(bounds.width, bounds.height) * cornerRadius
            }
            configuration = config
        } else {
            if cornerRadius < 0 {
                layer.cornerRadius = min(bounds.width, bounds.height) / 2
            } else {
                layer.cornerRadius = min(bounds.width, bounds.height)  * cornerRadius
            }
            layer.masksToBounds = true
        }
    }
}
