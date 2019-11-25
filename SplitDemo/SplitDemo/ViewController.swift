//
//  ViewController.swift
//  SplitDemo
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let viewModel = SectionViewModel()

    var isSectionFolding = BehaviorRelay<(row: Int, isFolding: Bool)>(value: (0, false))

    var publishSubject = PublishSubject<(row: Int, isFolding: Bool)>()

    var bag = DisposeBag()

    var child: SideMenuViewController? {
        return self.children.first as? SideMenuViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "CustomHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "header")

        NotificationCenter.default.addObserver(self, selector: #selector(didClickSideMenuOption(_:)), name: .didClickSideMenuOption, object: nil)

        publishSubject.subscribe(
            onNext: {
                print("\($0)")
                if let header = self.tableView.headerView(forSection: $0.row) as? CustomHeader {
                    let section = self.viewModel.sections[$0.row]
                    self.headerViewAction(headerView: header, section: section)
                }
            }
        ).disposed(by: bag)


    }

    @objc fileprivate func didClickSideMenuOption(_ notification: Notification) {
        if let section = notification.userInfo?["Section"] as? Int, let header = tableView.headerView(forSection: section) as? CustomHeader {
            let section = viewModel.sections[section]
            section.isFolding = (section.isFolding == true) ? false : true
            headerViewAction(headerView: header, section: section)
        }
    }

}

extension ViewController: HeaderViewProtocol {
    func headerView(headerView: CustomHeader, didClicked section: Section) {
        headerViewAction(headerView: headerView, section: section)
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
        if viewModel.sections[section].isFolding == true {
            return 0
        } else {
            return viewModel.sections[section].data.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let text = viewModel.sections[indexPath.section].data[indexPath.row]
        cell.textLabel?.text = text
        return cell
    }

    // Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CustomHeader
        header?.setup(section: viewModel.sections[section])
        header?.delegate = self
        return header
    }
}
