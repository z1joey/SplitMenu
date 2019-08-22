//
//  SideMenuViewController.swift
//  SplitDemo
//

import UIKit

class SideMenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var options = ["book", "headphones", "monitor", "photo-camera"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SideMenuCell
        let option = options[indexPath.row]
        cell?.setup(text:option, image: UIImage(named: option))
        return cell ?? SideMenuCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }

}
