//
//  ViewController.swift
//  SplitDemo
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var publishSubject = PublishSubject<(row: Int, isFolding: Bool)>()

    var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "CustomHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "header")

        publishSubject.subscribe(
            onNext: { [weak self] in
                print("\($0)")
                if let header = self?.tableView.headerView(forSection: $0.row) as? CustomHeader {
                    let section = ViewModel.section.sections[$0.row]
                    self?.headerViewAction(headerView: header, section: section)
                }
            },
            onDisposed: {
                print("Publish subject disposed")
            }
        ).disposed(by: bag)
    }

    deinit {
        print("Deinit: \(self.description)")
    }

    fileprivate func headerViewAction(headerView: CustomHeader, section: Section) {
        headerView.isUserInteractionEnabled = false

        var indexPaths = [IndexPath]()

        for i in 0..<section.data.count {
            let indexPath = IndexPath.init(row: i, section: section.id)
            indexPaths.append(indexPath)
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            if section.isFolding == true {
                self.tableView.deleteRows(at: indexPaths, with: .top)
            } else {
                self.tableView.insertRows(at: indexPaths, with: .top)
                let indexSection = IndexPath.init(row: 0, section: section.id)
                self.tableView.scrollToRow(at: indexSection, at: .middle, animated: true)
            }
            headerView.isUserInteractionEnabled = true
        }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ViewModel.section.sections[section].isFolding == true {
            return 0
        } else {
            return ViewModel.section.sections[section].data.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let text = ViewModel.section.sections[indexPath.section].data[indexPath.row]
        cell.textLabel?.text = text
        return cell
    }

    // Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return ViewModel.section.sections.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CustomHeader
        header?.setup(section: ViewModel.section.sections[section])
        return header
    }
}
