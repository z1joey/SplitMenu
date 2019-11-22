//
//  SideMenuViewController.swift
//  SplitDemo
//

import UIKit
import RxSwift
import RxCocoa

struct CellInfo {
    let title: String
    let image: UIImage?
}

class SideMenuViewController: UIViewController {

    var cellInfo: Observable<[CellInfo]> = Observable<[CellInfo]>.just([
        CellInfo(title: "Title1", image: UIImage(named: "book")),
        CellInfo(title: "Title2", image: UIImage(named: "headphones")),
        CellInfo(title: "Title3", image: UIImage(named: "monitor")),
        CellInfo(title: "Title4", image: UIImage(named: "photo-camera"))
    ])

    var bag = DisposeBag()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = 100
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindTableView()
        bindTapAction()
    }

    fileprivate func bindTableView() {
        cellInfo
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { row, info, cell in
                if let cell = cell as? SideMenuCell {
                    cell.setup(info: info)
                }
            }.disposed(by: bag)
    }

    fileprivate func bindTapAction() {
        tableView.rx.modelSelected(CellInfo.self).subscribe { cellInfo in
            print(cellInfo.element?.title)
        }.disposed(by: bag)
    }

}

extension Notification.Name {
    static let didClickSideMenuOption = Notification.Name("didClickSideMenuOption")
}
