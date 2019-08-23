//
//  ViewController.swift
//  SplitDemo
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "CustomHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "header")

        generateSections()

        NotificationCenter.default.addObserver(self, selector: #selector(didClickSideMenuOption(_:)), name: .didClickSideMenuOption, object: nil)
    }

    fileprivate func generateSections() {
        for i in 0...5 {
            let section = Section(id: i, title: "ID \(i)", data: ["Chinese", "English", "Japanese", "Germany", "Thailand", "Australia"], isFolding: true)
            sections.append(section)
        }
    }

    @objc fileprivate func didClickSideMenuOption(_ notification: Notification) {
        if let section = notification.userInfo?["Section"] as? Int, let header = tableView.headerView(forSection: section) as? CustomHeader {
            let section = sections[section]
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
        if sections[section].isFolding == true {
            return 0
        } else {
            return sections[section].data.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let text = sections[indexPath.section].data[indexPath.row]
        cell.textLabel?.text = text
        return cell
    }

    // Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CustomHeader
        header?.setup(section: sections[section])
        header?.delegate = self
        return header
    }
}
