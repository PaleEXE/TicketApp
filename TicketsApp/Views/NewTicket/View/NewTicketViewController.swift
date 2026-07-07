import UIKit
import RxSwift
import RxCocoa

class NewTicketViewController: AppViewController {
    @IBOutlet weak var newTicketView: UIView!
    @IBOutlet weak var ticketDetailsView: UIView!
    @IBOutlet weak var ticketTypeTextField: PickerTextField!
    @IBOutlet weak var ticketSubTypeTextField: PickerTextField!
    @IBOutlet weak var priorityCollectionView: UICollectionView!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!

    private let ticketTypePicker = UIPickerView()
    private let ticketSubTypePicker = UIPickerView()

    let vm = NewTicketViewModel()
    var ticketsVM = TicketsViewModel()
    let disposeBag = DisposeBag()
    private var mode: ViewMode = .newTicket

    init(with ticketsVM: TicketsViewModel, as mode: ViewMode) {
        self.ticketsVM = ticketsVM
        self.mode = mode
        super.init(nibName: "NewTicketViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGlobalStyles()

        switch mode {
        case .newTicket:
            newTicketView.isHidden = false
            ticketDetailsView.isHidden = true
            title = "New Ticket"
            setupUIAsNewTicket()
        case .ticketDetails:
            newTicketView.isHidden = true
            ticketDetailsView.isHidden = false
            title = "Ticket Details"
            setupUIAsTicketDetails()
        }

        setupSubmitButton()
    }

    private func setupGlobalStyles() {
        newTicketView.layer.cornerRadius = 12
        newTicketView.clipsToBounds = true

        ticketDetailsView.layer.cornerRadius = 12
        ticketDetailsView.clipsToBounds = true

        ticketTypeTextField.layer.cornerRadius = 8
        ticketTypeTextField.clipsToBounds = true

        ticketSubTypeTextField.layer.cornerRadius = 8
        ticketSubTypeTextField.clipsToBounds = true

        priorityCollectionView.layer.cornerRadius = 8
        priorityCollectionView.clipsToBounds = true

        detailsTableView.layer.cornerRadius = 12
        detailsTableView.clipsToBounds = true

        submitButton.layer.cornerRadius = 8
        submitButton.clipsToBounds = true

        descriptionTextView.layer.cornerRadius = 12
        descriptionTextView.clipsToBounds = true
    }

    func setupUIAsTicketDetails() {
        detailsTableView.isScrollEnabled = false
        detailsTableView.rowHeight = UITableView.automaticDimension
        detailsTableView.estimatedRowHeight = 65
        detailsTableView.tableFooterView = UIView(frame: .zero)
        detailsTableView.separatorInset = .zero
        detailsTableView.layoutMargins = .zero

        detailsTableView.register(
            UINib(nibName: "TicketDetailsTableViewCell", bundle: nil),
            forCellReuseIdentifier: "TicketDetailsTableViewCell"
        )

        let valuesObservable = ticketsVM.selectedTicket
            .compactMap { $0 }
            .map { ticket -> [TicketDetailsTableViewCellModel] in
                var models = Mirror(reflecting: ticket).children
                    .filter { $0.label != "description" }
                    .compactMap { child in
                        let label = child.label ?? "ERR"
                        let val: DetailsValue = {
                            if let status = child.value as? TicketStatus {
                                return .status(status)
                            } else {
                                return .normal("\(child.value)")
                            }
                        }()
                        return TicketDetailsTableViewCellModel(title: label.fromCamelToTitle(), value: val)
                    }

                if let idx = models.firstIndex(where: {
                    if case .status = $0.value.value { return true }
                    return false
                }) {
                    models.swapAt(0, idx)
                }

                return models
            }

        valuesObservable
            .bind(to: detailsTableView.rx.items(
                cellIdentifier: "TicketDetailsTableViewCell",
                cellType: TicketDetailsTableViewCell.self
            )) { _, vm, cell in
                cell.bind(to: vm)
            }
            .disposed(by: disposeBag)

        valuesObservable
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.detailsTableView.invalidateIntrinsicContentSize()
                    self?.detailsTableView.superview?.setNeedsLayout()
                    self?.detailsTableView.superview?.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)

        ticketsVM.selectedTicket
            .map { $0?.description }
            .asDriver(onErrorJustReturn: "ERR")
            .drive(descriptionTextView.rx.text)
            .disposed(by: disposeBag)
    }

    func setupUIAsNewTicket() {
        setupPicker(textField: ticketTypeTextField, pickerView: ticketTypePicker, data: vm.ticketTypes, targetRelay: vm.selectedTicketType)
        setupPicker(textField: ticketSubTypeTextField, pickerView: ticketSubTypePicker, data: vm.ticketSubTypes, targetRelay: vm.selectedTicketSubType)
        setupPriorityCollectionView()
        setupBackgroundTap()
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
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPicker))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        return toolbar
    }

    @objc private func dismissPicker() {
        view.endEditing(true)
    }

    func setupPriorityCollectionView() {
        guard let layout = priorityCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.invalidateLayout()

        priorityCollectionView.showsHorizontalScrollIndicator = false
        priorityCollectionView.register(UINib(nibName: "PriorityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PriorityCollectionViewCell")

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
                guard let self = self else { return }
                self.vm.selectedPriority.accept(tappedPriority)
            })
            .disposed(by: disposeBag)
    }

    func setupSubmitButton() {
        let buttonTitle = mode == .ticketDetails ? "Close Ticket" : "Submit"

        if var config = submitButton.configuration {
            config.title = buttonTitle
            submitButton.configuration = config
        } else {
            submitButton.setTitle(buttonTitle, for: .normal)
        }

        submitButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                switch self.mode {
                case .newTicket:
                    self.handleNewTicketSubmission()
                case .ticketDetails:
                    self.handleCloseTicketAction()
                }
            })
            .disposed(by: disposeBag)
    }

    private func handleNewTicketSubmission() {
        let type = vm.selectedTicketType.value
        let subType = vm.selectedTicketSubType.value
        let priority = vm.selectedPriority.value

        if type == nil || type?.isEmpty == true {
            showAlert(title: "Alert", message: "Please select a ticket type.")
            return
        }

        if subType == nil || subType?.isEmpty == true {
            showAlert(title: "Alert", message: "Please select a ticket sub-type.")
            return
        }

        if priority == nil {
            showAlert(title: "Alert", message: "Please select a priority.")
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let currentDateString = formatter.string(from: Date())
        let description = vm.description.value

        let newTicket = Ticket(
            id: "\(2005 + ticketsVM.tickets.value.count)",
            type: type!,
            subType: subType!,
            date: currentDateString,
            description: description,
            priority: priority!.priority,
            status: .progress
        )

        var tickets = ticketsVM.tickets.value
        tickets.append(newTicket)
        ticketsVM.tickets.accept(tickets)
        navigationController?.popViewController(animated: true)
        showAlert(title: "Success", message: "New ticket was added")
    }

    private func handleCloseTicketAction() {
        var ticket = self.ticketsVM.selectedTicket.value
        ticket?.status = .closed
        self.ticketsVM.selectedTicket.accept(ticket)
        navigationController?.popViewController(animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
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
        let stackSpacing: CGFloat = 6

        let totalComputedWidth = ceil(textWidth + leftRightEdgePadding + stackSpacing)

        return CGSize(width: totalComputedWidth, height: collectionView.bounds.height)
    }
}
