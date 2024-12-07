//
//  MyGardenCell.swift
//  PlantID

import UIKit

fileprivate struct Colors {
    static let activeColor = UIColor(hexString: "#2DFF75")
    static let defaultColor = UIColor(hexString: "#CDCFCC")
}

@objc protocol MyGardenCellDelegate: AnyObject {
    func myGardenCellRemove(_ myGardenCell: MyGardenCell)
    func myGardenCellWatering(_ myGardenCell: MyGardenCell, isOverdue: Bool)
    func myGardenCellSpraying(_ myGardenCell: MyGardenCell, isOverdue: Bool)
    func myGardenCellWFertilize(_ myGardenCell: MyGardenCell, isOverdue: Bool)
}

class MyGardenCell: UITableViewCell {
    
    @IBOutlet private weak var plantImageView: UIImageView!
    @IBOutlet private weak var plantNameLabel: UILabel!
    @IBOutlet private weak var plantDescLabel: UILabel!
    
    weak var delegate: MyGardenCellDelegate?
    
    var wateringDateOverdue = false
    var sprayingDateOverdue = false
    var fertilizeDateOverdue = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        plantImageView.image = nil
        plantNameLabel.text = nil
    }
    
    func configure() {
        plantImageView.layer.borderWidth = 1
        plantImageView.layer.borderColor = UIColor(hexString: "#F6E650")!.cgColor
     }
    
    func fill(_ object: PlantIdentificationResponse) {
        plantImageView.image = UIImage(data: object.localImageData!)
        plantNameLabel.text = object.suggestions.first?.plantName
        plantDescLabel.text = object.suggestions.first!.plantDetails?.wikiDescription?.value ?? ""
    }
}
