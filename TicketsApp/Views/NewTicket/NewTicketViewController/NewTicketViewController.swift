import UIKit
import RxSwift
import RxCocoa

class NewTicketViewController: AppViewController {

    @IBOutlet weak var ticketTypeTextField: PickerTextField!
    @IBOutlet weak var ticketSubTypeTextField: PickerTextField!
    @IBOutlet weak var priorityCollectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!

    private let ticketTypePicker = UIPickerView()
    private let ticketSubTypePicker = UIPickerView()

    let vm = NewTicketViewModel()
    var ticketsVM = TicketsViewModel()
    let disposeBag = DisposeBag()

    init(with ticketsVM: TicketsViewModel) {
        self.ticketsVM = ticketsVM
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
        setupPicker(textField: ticketTypeTextField, pickerView: ticketTypePicker, data: vm.ticketTypes, targetRelay: vm.selectedTicketType)
        setupPicker(textField: ticketSubTypeTextField, pickerView: ticketSubTypePicker, data: vm.ticketSubTypes, targetRelay: vm.selectedTicketSubType)
        setupPriorityCollectionView()
        setupSubmitButton()
    }

    private func setupPicker(textField: UITextField, pickerView: UIPickerView, data: BehaviorRelay<[String]>, targetRelay: BehaviorRelay<String?>) {
        textField.inputView = pickerView
        textField.inputAccessoryView = createToolbar()

        data
            .bind(to: pickerView.rx.itemTitles) { _, item in
                return item
            }
            .disposed(by: disposeBag)

        let selection = pickerView.rx.modelSelected(String.self)
            .compactMap { $0.first }
            .share()

        selection
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)

        selection
            .bind(to: targetRelay)
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

    func setupSubmitButton() {
        submitButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }

                let type = self.vm.selectedTicketType.value
                let subType = self.vm.selectedTicketSubType.value
                let priority = self.vm.selectedPriority.value

                if type == nil || type?.isEmpty == true {
                    self.showAlert(title: "Alert", message: "Please select a ticket type.")
                    return
                }

                if subType == nil || subType?.isEmpty == true {
                    self.showAlert(title: "Alert", message: "Please select a ticket sub-type.")
                    return
                }

                if priority == nil {
                    self.showAlert(title: "Alert", message: "Please select a priority.")
                    return
                }

                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM yyyy"
                let currentDateString = formatter.string(from: Date())

                let description = self.vm.description.value

                let newTicket = Ticket(
                    id: "\(2005 + self.ticketsVM.tickets.value.count)",
                    type: type!,
                    subType: subType!,
                    date: currentDateString,
                    description: description,
                    priority: priority!.priority,
                    status: .progress
                )

                var tickets = self.ticketsVM.tickets.value
                tickets.append(newTicket)
                self.ticketsVM.tickets.accept(tickets)
                self.navigationController?.popViewController(animated: true)
                showAlert(title: "Sucsess", message: "New ticket was added")
            })
            .disposed(by: disposeBag)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
