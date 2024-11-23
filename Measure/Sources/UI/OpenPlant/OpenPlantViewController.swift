//
//  OpenPlantViewController.swift
//  PlantNEW

import UIKit

final class OpenPlantViewController: BaseViewController {
    
    // MARK: -
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var plantTitleLabel: UILabel!
    @IBOutlet private weak var plantDescLabel: UILabel!
    @IBOutlet private var images: [UIImageView]!
    @IBOutlet private var topTitles: [UILabel]!
    @IBOutlet private var bottomTitles: [UILabel]!
    @IBOutlet private var careButtons: [UIButton]!
    
    // MARK: -
    
    var wateringDateOverdue = false
    var potDateOverdue = false
    var cutDateOverdue = false
    
    var plant: PlantIdentificationResponse!
    
    // MARK: -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        images[0].image = UIImage(named: "Detail-Water")!
        images[1].image = UIImage(named: "Detail-Pot")!
        images[2].image = UIImage(named: "Detail-Cut")!
        topImageView.layer.cornerRadius = 100
        topImageView.layer.borderColor = UIColor(hexString: "#0A9E03")?.cgColor
        topImageView.layer.borderWidth = 1
        
        if let imageData = plant.localImageData {
            topImageView.image = UIImage(data: imageData)
        } else {
            topImageView.image = UIImage(named: "Placeholder")
        }
        
        if let firstSuggestion = plant.suggestions.first {
            plantTitleLabel.text = firstSuggestion.plantName
            plantDescLabel.text = firstSuggestion.plantDetails?.wikiDescription?.value ?? "Description not available"
        } else {
            plantTitleLabel.text = "Unknown Plant"
            plantDescLabel.text = "Description not available"
        }
        
        if let wDate = plant.wateringDate {
            careButtons[0].backgroundColor = UIColor(hexString: "#FE8331")
            
        } else {
            careButtons[0].backgroundColor = UIColor(hexString: "#CFCFCF")
            bottomTitles[0].text = "No plan"
            careButtons[0].setTitle("No plan", for: .normal)
        }
        
        if let pot = plant.potDate {
            careButtons[1].backgroundColor = UIColor(hexString: "#FE8331")
        } else {
            careButtons[1].backgroundColor = UIColor(hexString: "#CFCFCF")
            bottomTitles[1].text = "No plan"
            careButtons[1].setTitle("No plan", for: .normal)
        }
        
        if let cut = plant.cutDate {
            careButtons[2].backgroundColor = UIColor(hexString: "#FE8331")
        } else {
            careButtons[2].backgroundColor = UIColor(hexString: "#CFCFCF")
            bottomTitles[2].text = "No plan"
            careButtons[2].setTitle("No plan", for: .normal)
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func waterAction(_ sender: UIButton) {
        
    }

    @IBAction func potAction(_ sender: UIButton) {
        
    }
    
    @IBAction func cutAction(_ sender: UIButton) {
        
    }
}
