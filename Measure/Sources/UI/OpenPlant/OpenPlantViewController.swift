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
    @IBOutlet private weak var menuButton: UIButton!
    
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
//        setupMenuInteraction()
    }
    
//    private func setupMenuInteraction() {
//        let interaction = UIContextMenuInteraction(delegate: self)
//        menuButton.addInteraction(interaction)
//    }
    
    func configure() {
        images[0].image = UIImage(named: "Detail-Water")!
        images[1].image = UIImage(named: "Detail-Pot")!
        images[2].image = UIImage(named: "Detail-Cut")!
        topImageView.layer.cornerRadius = 100
        topImageView.layer.borderColor = UIColor(hexString: "#F6E650")?.cgColor
        topImageView.layer.borderWidth = 1
        
        if let imageData = plant.localImageData {
            topImageView.image = UIImage(data: imageData)
        } else {
            topImageView.image = UIImage(named: "Placeholder")
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        if let firstSuggestion = plant.suggestions.first {
            plantTitleLabel.text = firstSuggestion.plantName
            plantDescLabel.text = firstSuggestion.plantDetails?.wikiDescription?.value ?? "Description not available"
        } else {
            plantTitleLabel.text = "Unknown Plant"
            plantDescLabel.text = "Description not available"
        }
        
        if let wDate = plant.wateringDate {
            careButtons[0].backgroundColor = UIColor(hexString: "#58855E")
            
            let components = calendar.dateComponents([.day], from: currentDate, to: wDate)
            let daysDifference = components.day ?? 0
            if daysDifference == 0 {
                bottomTitles[0].text = "Today"
                wateringDateOverdue = true
            } else if daysDifference < 0 {
                bottomTitles[0].text = "\(-daysDifference) days overdue"
                wateringDateOverdue = true
            } else {
                bottomTitles[0].text = "in \(daysDifference) days"
                wateringDateOverdue = false
            }
            if daysDifference <= 0 {
                bottomTitles[0].layer.borderColor = UIColor(hexString: "#ED675E")!.cgColor
            }
            
        } else {
            careButtons[0].backgroundColor = UIColor(hexString: "#CFCFCF")
            bottomTitles[0].text = "No plan"
            careButtons[0].setTitle("No plan", for: .normal)
        }
        
        if let pot = plant.potDate {
            careButtons[1].backgroundColor = UIColor(hexString: "#58855E")
            
            let components = calendar.dateComponents([.day], from: currentDate, to: pot)
            let daysDifference = components.day ?? 0
            if daysDifference == 0 {
                bottomTitles[1].text = "Today"
                wateringDateOverdue = true
            } else if daysDifference < 0 {
                bottomTitles[1].text = "\(-daysDifference) days overdue"
                wateringDateOverdue = true
            } else {
                bottomTitles[1].text = "in \(daysDifference) days"
                wateringDateOverdue = false
            }
            if daysDifference <= 0 {
                bottomTitles[1].layer.borderColor = UIColor(hexString: "#ED675E")!.cgColor
            }
            
        } else {
            careButtons[1].backgroundColor = UIColor(hexString: "#CFCFCF")
            bottomTitles[1].text = "No plan"
            careButtons[1].setTitle("No plan", for: .normal)
        }
        
        if let cut = plant.cutDate {
            careButtons[2].backgroundColor = UIColor(hexString: "#58855E")
            
            let components = calendar.dateComponents([.day], from: currentDate, to: cut)
            let daysDifference = components.day ?? 0
            if daysDifference == 0 {
                bottomTitles[2].text = "Today"
                wateringDateOverdue = true
            } else if daysDifference < 0 {
                bottomTitles[2].text = "\(-daysDifference) days overdue"
                wateringDateOverdue = true
            } else {
                bottomTitles[2].text = "in \(daysDifference) days"
                wateringDateOverdue = false
            }
            if daysDifference <= 0 {
                bottomTitles[2].layer.borderColor = UIColor(hexString: "#ED675E")!.cgColor
            }
            
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
        let menu = UIMenu(title: "", children: [
              UIAction(title: "Edit", image: UIImage(systemName: "pencil"), handler: { _ in
                  self.editPlant()
              }),
              UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in
                  self.deletePlant()
              })
          ])
          
          sender.showsMenuAsPrimaryAction = true
          sender.menu = menu
    }

    @IBAction func waterAction(_ sender: UIButton) {
        
    }

    @IBAction func potAction(_ sender: UIButton) {
        
    }
    
    @IBAction func cutAction(_ sender: UIButton) {
        
    }
}

extension OpenPlantViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return UIMenu(title: "", children: [
                UIAction(title: "Edit", image: UIImage(systemName: "pencil"), handler: { _ in
                    self.editPlant()
                }),
                UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in
                    self.deletePlant()
                })
            ])
        }
    }
    
    private func editPlant() {
        let editPlantViewController = EditPlantViewController()
        self.navigationController?.pushViewController(editPlantViewController, animated: true)
    }
    
    private func deletePlant() {
        let vc = MyGardenRemoveViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
}

extension OpenPlantViewController: MyGardenRemoveViewControllerDelegate {
    
    func myGardenRemoveViewControllerDelet(_ controller: MyGardenRemoveViewController) {
        do {
            try mainRealm.write {
                mainRealm.delete(plant)
                self.navigationController?.popToRootViewController(animated: true)
            }
        } catch {
            print("Error deleting plant: \(error.localizedDescription)")
        }
    }
}
