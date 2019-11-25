//
//  CustomHeader.swift
//  SplitDemo
//

import UIKit

class CustomHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicatorImageView: UIImageView!

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

    func setup(section: Section) {
        self.section = section
    }

}
