import UIKit
import RxSwift
import RxCocoa

class CommentsViewController: UIViewController {
    @IBOutlet weak var commentsTableView: UITableView!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        commentsTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = 267

        Observable.just(["Dummy 1", "Dummy 2"])
            .bind(to: commentsTableView.rx.items(cellIdentifier: "CommentTableViewCell", cellType: CommentTableViewCell.self)) { row, item, cell in

            }
            .disposed(by: disposeBag)
    }
}
