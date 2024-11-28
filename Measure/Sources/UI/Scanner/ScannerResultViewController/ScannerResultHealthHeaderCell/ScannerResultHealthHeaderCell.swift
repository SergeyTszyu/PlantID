//
//  ScannerResultHealthHeaderCell.swift
//  PlantNEW

import UIKit

class ScannerResultHealthHeaderCell: UITableViewCell {
    
    @IBOutlet private weak var plantImaggegVIeew: UIImageView!
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var bottomLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fill(_ obj: PlantResponse, image: UIImage, plantName: String) {
        plantImaggegVIeew.layer.cornerRadius = 60
        plantImaggegVIeew.image = image
        topLabel.text = plantName
        bottomLabel.text = obj.healthAssessment!.diseases.first!.diseaseDetails?.plantDescription
    }
}
