import UIKit
import RxSwift
import RxCocoa

class NewTicketViewController: AppViewController {

    @IBOutlet weak var ticketTypeTextField: PickerTextField!
    @IBOutlet weak var ticketSubTypeTextField: PickerTextField!
    @IBOutlet weak var priorityCollectionView: UICollectionView!

    private let ticketTypePicker = UIPickerView()
    private let ticketSubTypePicker = UIPickerView()

    let vm = NewTicketViewModel()
    let disposeBag = DisposeBag()

    init() {
        super.init(nibName: "NewTicketViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Ticket"
        setupUI()
    }

    func setupUI() {
        setupPicker(textField: ticketTypeTextField, pickerView: ticketTypePicker, data: vm.ticketTypes)
        setupPicker(textField: ticketSubTypeTextField, pickerView: ticketSubTypePicker, data: vm.ticketSubTypes)
        setupPriorityCollectionView()
    }

    private func setupPicker(textField: UITextField, pickerView: UIPickerView, data: BehaviorRelay<[String]>) {
        textField.inputView = pickerView
        textField.inputAccessoryView = createToolbar()

        data
            .bind(to: pickerView.rx.itemTitles) { _, item in
                return item
            }
            .disposed(by: disposeBag)

        pickerView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak textField] selected in
                if let title = selected.first {
                    textField?.text = title
                    print("Selected target filter: \(title)")
                }
            })
            .disposed(by: disposeBag)
    }

    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPicker))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        return toolbar
    }

    @objc private func dismissPicker() {
        view.endEditing(true)
    }

    func setupPriorityCollectionView() {
        guard let layout = priorityCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        layout.itemSize = CGSize(
            width:  layout.itemSize.width,
            height: priorityCollectionView.bounds.height
        )
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        layout.invalidateLayout()

        priorityCollectionView.showsHorizontalScrollIndicator = false

        priorityCollectionView
            .register(UINib(nibName: "PriorityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PriorityCollectionViewCell")

        priorityCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        vm.priorities
            .bind(to: priorityCollectionView.rx.items(
                cellIdentifier: "PriorityCollectionViewCell",
                cellType: PriorityCollectionViewCell.self
            )) { _, pri, cell in
                let cellViewModel = PriorityCollectionViewCellModel(model: pri)
                cell.bind(to: cellViewModel)
            }
            .disposed(by: disposeBag)

        priorityCollectionView.rx
            .modelSelected(Priority.self)
            .subscribe(onNext: { [weak self] tappedPriority in
                guard let self else { return }
                self.vm.selectedPriority.accept(tappedPriority)
            })
            .disposed(by: disposeBag)
    }
}

extension NewTicketViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let priorities = vm.priorities.value
        guard indexPath.row < priorities.count else { return .zero }

        let text = priorities[indexPath.row].priority.title

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
