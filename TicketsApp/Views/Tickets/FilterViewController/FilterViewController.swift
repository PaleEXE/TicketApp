import UIKit
import RxSwift
import RxCocoa

class FilterViewController: UIViewController {
    @IBOutlet weak var filterOptionsCollectionView: UICollectionView!
    @IBOutlet weak var applyButton: UIButton!

    let applyTappedSubject = PublishSubject<[FilterOption]>()

    var applyTapped: Observable<[FilterOption]> {
        applyTappedSubject.asObservable()
    }

    let disposeBag = DisposeBag()
    var vm = FilterViewModel(alreadySelected: [])

    init(alreadySelected: [FilterOption]) {
        super.init(nibName: "FilterViewController", bundle: nil)
        vm = FilterViewModel(alreadySelected: alreadySelected)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindApplyButton()
        bindFilterOptionsCollectionView()
    }

    func bindApplyButton() {
        applyButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.applyTappedSubject.onNext(self.vm.selectedOptions.value)
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    func bindFilterOptionsCollectionView() {
        guard let layout = filterOptionsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        layout.itemSize = CGSize(
            width:  layout.itemSize.width,
            height: filterOptionsCollectionView.bounds.height,
        )
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        layout.invalidateLayout()

        filterOptionsCollectionView.showsHorizontalScrollIndicator = false
        
        filterOptionsCollectionView
            .register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FilterCollectionViewCell")

        filterOptionsCollectionView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)

        vm.filterOptions
            .bind(to: filterOptionsCollectionView.rx.items(
                cellIdentifier: "FilterCollectionViewCell",
                cellType: FilterCollectionViewCell.self
            )) { _, opt, cell in
                let vm = FilterCollectionViewCellModel(model: opt)
                cell.bind(to: vm)
            }
            .disposed(by: disposeBag)

        filterOptionsCollectionView.rx
            .modelSelected(FilterOption.self)
            .subscribe(onNext: { [weak self] tappedFilter in
                guard let self else { return }
                self.vm.selectedOption.accept(tappedFilter)
            })
            .disposed(by: disposeBag)
    }
}

extension FilterViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let options = vm.filterOptions.value
        guard indexPath.row < options.count else { return .zero }

        let text = options[indexPath.row].label

        let font = UIFont.systemFont(ofSize: 17)
        let textAttributes = [NSAttributedString.Key.font: font]

        let maxExpectedSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: collectionView.bounds.height)

        let textWidth = text.boundingRect(
            with: maxExpectedSize,
            options: [.usesLineFragmentOrigin],
            attributes: textAttributes,
            context: nil
        ).width

        let leftRightEdgePadding: CGFloat = 24
        let imageWidth: CGFloat = 20.33
        let stackSpacing: CGFloat = 6

        let totalComputedWidth = ceil(textWidth + leftRightEdgePadding + imageWidth + stackSpacing)

        return CGSize(width: totalComputedWidth, height: collectionView.bounds.height)
    }
}
