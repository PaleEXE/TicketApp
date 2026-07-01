import UIKit

class PlusButton: UIButton {

    private var baseTitle: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }

    private func setupStyle() {
        titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        layer.cornerRadius = 18 // Adjust based on your exact height to make it a perfect pill
        clipsToBounds = true

        // Handle padding depending on iOS version
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            self.configuration = config
        } else {
            contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        }
    }

    func configure(title: String) {
        self.baseTitle = title
        updateAppearance()
    }

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    private func updateAppearance() {
        if isSelected {
            // Selected State: Blue background, white text, no prefix
            backgroundColor = UIColor(red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0) // System Blue
            setTitleColor(.white, for: .normal)
            setTitle(baseTitle, for: .normal)
        } else {
            // Unselected State: Light gray background, dark gray text
            backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            setTitleColor(.darkGray, for: .normal)

            // Add the "+" prefix if it's unselected (and not the "All" button)
            if baseTitle.lowercased() != "all" {
                setTitle("+ \(baseTitle)", for: .normal)
            } else {
                setTitle(baseTitle, for: .normal)
            }
        }
    }
}
