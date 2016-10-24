//
//  LabelCell.swift
//  Yelp
//
//  Created by Ryan Chee on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol LabelCellDelegate {
    @objc optional func labelCell(labelCell: LabelCell)
}
class LabelCell: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    var cellSelected = false
    weak var delegate: LabelCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func labelSelected() {
        delegate?.labelCell?(labelCell: self)
        print("labelselected changed")
    }

}
