//
//  ScannerNotFoundViewController.swift
//  PlantID

import UIKit

enum ScannerResultType {
    case notFound
    case isHealthy
}

class ScannerNotFoundViewController: BaseViewController {
    
    @IBOutlet private weak var againButton: UIButton!
    @IBOutlet private weak var typeImagegVIew: UIImageView!
    @IBOutlet private weak var topTextLabel: UILabel!
    @IBOutlet private weak var bottomTextLabel: UILabel!
    
    var ccannerResultType: ScannerResultType = .notFound
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch ccannerResultType {
        case .notFound:
            topTextLabel.text = "Plant not found"
            bottomTextLabel.text = "Please try again. Check image quality, angle and lighting"
        case .isHealthy:
            topTextLabel.text = "Plant not found"
            bottomTextLabel.text = "Please try again. Check image quality, angle and lighting"
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func retryAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = false
        }
    }
    
}
