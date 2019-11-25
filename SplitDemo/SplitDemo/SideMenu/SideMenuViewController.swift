//
//  SideMenuViewController.swift
//  SplitDemo
//

import UIKit
import RxSwift
import RxCocoa

class SideMenuViewController: UIViewController {

    var bag = DisposeBag()

    var container: ViewController? {
        return self.parent as? ViewController
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = 100
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRxTableview()
    }

    fileprivate func setupRxTableview() {
        /// Data Source
        sectionViewModel.sideMenuOptions
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { row, option, cell in
                if let cell = cell as? SideMenuCell {
                    cell.setup(option: option)
                }
            }.disposed(by: bag)

        /// Tap Action
        tableView.rx.itemSelected.subscribe(
            onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                sectionViewModel.sections[indexPath.row].isFolding.toggle()
                let section = sectionViewModel.sections[indexPath.row]
                self.container?.publishSubject
                    .onNext((row: indexPath.row, isFolding: section.isFolding))
            },
            onCompleted: {
                print("Tap Action Completed")
            },
            onDisposed: {
                print("Tap Action Disposed")
            }
        ).disposed(by: bag)
    }
    
}
