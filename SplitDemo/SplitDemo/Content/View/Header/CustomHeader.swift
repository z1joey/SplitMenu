//
//  CustomHeader.swift
//  SplitDemo
//

import UIKit

protocol HeaderViewProtocol: class {
    func headerView(headerView: CustomHeader, didClicked section: Section)
}

class CustomHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicatorImageView: UIImageView!

    weak var delegate: HeaderViewProtocol?

    var isFolding: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.25) {
                switch self.isFolding {
                case true:
                    self.indicatorImageView.transform = CGAffineTransform(rotationAngle: 0)
                case false:
                    self.indicatorImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }
            }
        }
    }

    var section: Section? {
        didSet {
            titleLabel.text = section?.title
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addTapGesture()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTapGesture()
    }

    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
    }

    @objc func tapAction() {
        isFolding = (isFolding == true) ? false : true
        if let section = section {
            section.isFolding = isFolding
            delegate?.headerView(headerView: self, didClicked: section)
        }
    }

    func setup(section: Section) {
        self.section = section
    }

}
