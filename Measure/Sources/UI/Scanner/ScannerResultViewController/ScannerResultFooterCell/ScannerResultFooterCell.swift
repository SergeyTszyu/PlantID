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
    
    func fill(_ title: String, response: PlantResponse) {
        footerTitleLabel.text = title.capitalized
        var text = "\(response.healthAssessment!.diseases.first!.diseaseDetails!.plantDescription) \n"
        
        if let bio = response.healthAssessment!.diseases.first!.diseaseDetails!.treatment?.biological {
            if !bio.isEmpty {
                text.append("\n")
            }
            
            for (ind, str) in bio.enumerated() {
                text.append("   \(ind + 1). \(str)\n")
            }
        }
        
        if let bio = response.healthAssessment!.diseases.first!.diseaseDetails!.treatment?.chemical {
            
            if !bio.isEmpty {
                if !bio.isEmpty {
                    text.append("\n")
                }
            }
            
            for (ind, str) in bio.enumerated() {
                text.append("   \(ind + 1). \(str)\n")
            }
        }
        
        if let bio = response.healthAssessment!.diseases.first!.diseaseDetails!.treatment?.prevention {
            if !bio.isEmpty {
                if !bio.isEmpty {
                    text.append("\n")
                }
            }
            for (ind, str) in bio.enumerated() {
                text.append("   \(ind + 1). \(str)\n")
            }
        }
        
        footerBottomLabel.text = text
    }
}
