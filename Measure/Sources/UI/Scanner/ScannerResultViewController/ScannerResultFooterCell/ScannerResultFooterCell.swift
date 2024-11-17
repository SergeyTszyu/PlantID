//
//  ScannerResultFooterCell.swift
//  PlantNEW

import UIKit

class ScannerResultFooterCell: UITableViewCell {
    
    @IBOutlet private weak var footerTitleLabel: UILabel!
    @IBOutlet private weak var footerBottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fill(_ title: String, bottomText: String) {
        footerTitleLabel.text = title
        footerBottomLabel.text = bottomText
    }
}
