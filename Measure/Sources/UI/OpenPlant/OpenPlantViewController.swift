//
//  OpenPlantViewController.swift
//  PlantNEW

import UIKit

final class OpenPlantViewController: BaseViewController {
    
    // MARK: -
    
    @IBOutlet private var images: [UIImageView]!
    @IBOutlet private var topTitles: [UILabel]!
    @IBOutlet private var bottomTitles: [UILabel]!
    @IBOutlet private var careButtons: [UIButton]!
    
    // MARK: -
    
    var wateringDateOverdue = false
    var potDateOverdue = false
    var cutDateOverdue = false
    
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
