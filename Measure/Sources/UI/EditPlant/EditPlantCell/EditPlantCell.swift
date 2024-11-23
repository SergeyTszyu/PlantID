//
//  EditPlantCell.swift

import UIKit

fileprivate struct countOf {
    static let days = 7
    static let weeks = 4
    static let month = 12
}

final class EditPlantCell: UITableViewCell {
    
    @IBOutlet private var waterButtons: [UIButton]!
    @IBOutlet private var potButtons: [UIButton]!
    @IBOutlet private var cutButtons: [UIButton]!
    
    @IBOutlet private weak var waterMaximumLabel: UILabel!
    @IBOutlet private weak var potMaximumLabel: UILabel!
    @IBOutlet private weak var cutMaximumLabel: UILabel!
    
    @IBOutlet private weak var waterSlidedr: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configurr() {
        waterButtons[0].setTitle("Day", for: .normal)
        waterButtons[1].setTitle("Week", for: .normal)
        waterButtons[2].setTitle("Month", for: .normal)
        
        waterButtons.forEach { button in
            button.layer.cornerRadius = 10
        }
        
        waterSlidedr.setThumbImage(UIImage(named: "waterSlider"), for: .normal)
        waterSlidedr.setThumbImage(UIImage(named: "waterSlider"), for: .highlighted)
    }
    
    @IBAction func wateringAction() {
        
    }
    
}
