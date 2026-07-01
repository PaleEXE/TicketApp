import UIKit


class FilterViewController: UIViewController {
    @IBOutlet weak var filterOptionsCollectionView: UICollectionView!
    @IBOutlet weak var applyButton: UIButton!

    init() {
        super.init(nibName: "FilterViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
