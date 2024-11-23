//
//  ScannerResultHeaderCell.swift
//  PlantNEW
//
//  Created by Sergey Tszyu on 08.11.2024.
//

import UIKit

class ScannerResultHeaderCell: UITableViewCell {
    
    @IBOutlet private weak var plantImageVIew: UIImageView!
    @IBOutlet private weak var plantNameLabeel: UILabel!
    @IBOutlet private weak var plantDescLabel: UILabel!
    @IBOutlet private weak var plantToxicImage: UIImageView!
    @IBOutlet private weak var plantToxicText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fill(_ model: PlantIdentificationResponse, image: UIImage) {
        plantImageVIew.image = image
        plantDescLabel.text = "Exotic Elegance with Vibrant Blooms"
        plantNameLabeel.text = model.suggestions.first!.plantName
        if let tx = model.suggestions.first!.plantDetails?.toxicity, tx.isEmpty {
            plantToxicText.isHidden = true
            plantToxicImage.isHidden = true
        } else {
            plantToxicText.text = "Plant is toxic"
            
        }
        
    }
    
}
