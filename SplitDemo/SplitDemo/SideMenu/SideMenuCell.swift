//
//  SideMenuCell.swift
//  SplitDemo
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var optionTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(text: String, image: UIImage?) {
        optionTextLabel.text = text
        optionImageView.image = image
    }

}
